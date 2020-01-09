import groovy.json.JsonSlurper
/*
================================================================================
=                     Start Sinonkt Style Utils                                =
================================================================================
*/
def pathResolver(workflowHomePath) {
  return { path -> path.replace("env://", workflowHomePath + "/").replace("launchDir://", "${workflow.launchDir}/") }
}

def getDefaultParams(schema) {
  def workflowHomePath = schema.__WORKFLOW_HOME_PATH_BY_ENVIRONMENT[workflow.profile]
  def resolvePath = pathResolver(workflowHomePath)
  return schema.fields.inject([:]) { result, it -> 
    if (it.__need_resolve) {
      def keys = it.__need_resolve.keySet() as String[];
      def resolved = keys.inject([:]) { acc, key -> 
        def mapKey = it.__need_resolve[key]
        def resovledDefaultValue = it[mapKey][it.default]
        if (resovledDefaultValue instanceof Map) {
          def nestedKeys = resovledDefaultValue.keySet() as String[];
          def nestedResolved = nestedKeys.inject([:]) { nestedAcc, nestedKey ->
            def nestedResolvedDefaultValue = resovledDefaultValue[nestedKey]
            def defaultValue = nestedResolvedDefaultValue && ["path", "dir"].contains(it.__type) ? resolvePath(nestedResolvedDefaultValue) : nestedResolvedDefaultValue
            return [*:nestedAcc, "${nestedKey}": defaultValue]
          }
          return [*:acc, "$key": nestedResolved]
        }

        def defaultValue = resovledDefaultValue && ["path", "dir"].contains(it.__type) ? resolvePath(resovledDefaultValue) : resovledDefaultValue
        return [ *:acc, "$key": defaultValue]
      }
      return [ *:result, "${it.name}": it.default, *:resolved]
    }
    
    def defaultValue = it.default && ["path", "dir"].contains(it.__type) ? resolvePath(it.default) : it.default
    return [ *:result, "${it.name}": defaultValue ]
  }
}

def readAvroSchema(path) { (new JsonSlurper()).parse(new File(path)) }

def groupTupleWithoutCommonKey(channel, spreadTail) {
  channel.map { ['tempKey', *it] }
    .groupTuple()
    .map { it.tail() }
    .map { spreadTail ? [it.first(), it.tail().flatten()] : it }
}

def processName(task) { task.process.split(":").last() }

def workflowName(task) { task.process.split(":").first() }

def outputPrefixPath(params, task) { "${params.output}/${workflowName(task)}/${processName(task)}" }

def s3OutputPrefixPath(params, task) { "${params.s3output}/${workflowName(task)}/${processName(task)}" }
/*
================================================================================
=                     End Sinonkt Style Utils                                  =
================================================================================
*/