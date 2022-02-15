data "genesyscloud_flow" "get_flow" {
  depends_on = [
    null_resource.deploy_archy_flow_workflow
  ]
  name = "EventOrchestrator Flow"
}

resource "null_resource" "trigger" {
  depends_on = [
    null_resource.deploy_archy_flow_workflow,
    data.genesyscloud_flow.get_flow
  ]

   provisioner "local-exec" {
    command = "python3 workflow_trigger/trigger.py ${data.genesyscloud_flow.get_flow.id}"
  }
}

