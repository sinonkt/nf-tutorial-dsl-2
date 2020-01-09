import groovy.json.JsonSlurper
/*
================================================================================
=                     Start Sinonkt Style H E L P                              =
================================================================================
Synchronized with message value avro schema.
*/

include './log' params(params)
include pathResolver from './utils'

def showNextflowOptions(schema) {
  def envs = (schema.__WORKFLOW_HOME_PATH_BY_ENVIRONMENT.keySet() as String[]).join("|")

  log.info "Nextflow Options:"
	log.info "|   -profile  <${envs}> Profile/Executor you wish to run on."
	log.info "|   -hub           <seeds|nbt>            Pulls pipeline from this private repo."
	log.info "|                                         If not set, nextflow will lookup from public github repo."
	log.info "|--------------------------------------------------------------------------------------------------"
}

def printArg(workflowHomePath, field) {
    def resolvePath = pathResolver(workflowHomePath)
    if (field.type instanceof List) {
      def enumArg = field.type.tail().find({ it instanceof Map && it.type == "enum" })
      if (enumArg) {
        log.info "|   --${enumArg.name}  <${enumArg.symbols.join("|")}>     ${field.doc}"
        log.info "|                        (default=${enumArg.default})"
      } else {
        log.info "|   --${field.name}  <${field.__type ?: field.type}>     ${field.doc}"
        log.info "|                        (default=${field.default})"
      }
    } else if (field.type instanceof Map) {
      if (field.type.type == 'enum') {
        log.info "|   --${field.type.name}  <${field.type.symbols.join("|")}>     ${field.doc}"
        log.info "|                        (default=${field.type.default})"
      } else if (field.type.type == 'array') {
        log.info "|   --${field.name}  <[${field.type.items}]>     ${field.doc}"
        log.info "|                        (default=${field.default})"
      }
    } else if (field.type == 'enum') {
      log.info "|   --${field.name}  <${field.symbols.join("|")}>     ${field.doc}"
      log.info "|                        (default=${field.default})"
    } else {
      log.info "|   --${field.name}  <${field.__type ?: field.type}>     ${field.doc}"
      def defaultValue = field.default
      if (['path', 'dir'].contains(field.__type)) {
        defaultValue = resolvePath(field.default)
      }
      log.info "|                        (default=${defaultValue})"
    }
}

def showMandatoryArguments(schema) {
  def allRequiredArgs = schema.fields.findAll({ it.__required })
  def workflowHomePath = schema.__WORKFLOW_HOME_PATH_BY_ENVIRONMENT[workflow.profile]
  log.info "Mandatory arguments:"
  allRequiredArgs.each { printArg(workflowHomePath, it) }
	log.info "|--------------------------------------------------------------------------------------------------"
}

def showOptionsArguments(schema) {
  log.info "Options:"
  def optionalArgs = schema.fields.findAll({ !it.__required })
  def workflowHomePath = schema.__WORKFLOW_HOME_PATH_BY_ENVIRONMENT[workflow.profile]
  optionalArgs.each { printArg(workflowHomePath, it) }
	log.info "|--------------------------------------------------------------------------------------------------"
}

def helpMessage(schema) {
  log.info ""
  log.info "Current Nextflow Profile: ${workflow.profile}"
  log.info ""
  workflowVersionMessage()
  log.info ""
  log.info workflow.manifest.description
  log.info ""
  showNextflowOptions(schema)
  showMandatoryArguments(schema)
  showOptionsArguments(schema)
}

/*
================================================================================
=                       End Sinonkt Style H E L P                              =
================================================================================
*/