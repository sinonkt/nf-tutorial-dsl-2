
def affiliatesMessage() {
  log.info ""
  log.info " ~ powered by National Biobank Thailand, Seeds \\7 (Sinonkt) ~"
  log.info ""
}
/*
================================================================================
=                           Start Sarek Style L O G G I N G                    =
================================================================================
*/

def grabRevision() {
  return workflow.revision ?: workflow.commitId ?: workflow.scriptId.substring(0,10)
}

def workflowVersionMessage() {
  log.info "##### ${workflow.manifest.name} #####"
  log.info "- ${workflow.manifest.name ?: workflow.repository} ~ ${workflow.manifest.version} - " + grabRevision() + (workflow.commitId ? " [${workflow.commitId}]" : "")
}

def logList(list) {
  for (val in list) {
    log.info "\t- ${val}"
  }
}

def welcomeMessage() {
  workflowVersionMessage()
  log.info ""
  log.info workflow.manifest.description
  log.info ""
  log.info "Authors:"
  logList(workflow.manifest.author.split(','))
  log.info ""
  log.info "Maintainers:"
  logList(params.MAINTAINERS)
  affiliatesMessage()
}

def handleCompleteMessage() {
  log.info "Completed at: " + workflow.complete
  log.info "Duration    : " + workflow.duration
  log.info "Success     : " + workflow.success
  log.info "Exit status : " + workflow.exitStatus
  log.info "Error report: " + (workflow.errorReport ?: '-')
}

def handleErrorMessage() {
  log.info "Workflow execution stopped with the following message:"
  log.info "  " + workflow.errorMessage
}

/*
================================================================================
=                           End Sarek Style L O G G I N G                      =
================================================================================
*/