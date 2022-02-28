resource "local_file" "create_secureflow" {
    depends_on= [
      module.saveUserData_lambda_data_integration,
      module.saveUserData_lambda_data_action,
      module.paymentId_generator_lambda_data_integration,
      module.paymentID_lambda_data_action,
    ]
    content     = templatefile("architect-flow-templates/EventOrchestrator_Secure_Flow.tftpl", {dataAction = "${var.environment}-${var.generatePaymentId_prefix}"})
    filename = "architect-flows/EventOrchestrator_Secure_Flow.yaml"
}

resource "null_resource" "deploy_archy_flow_secureflow" {
  depends_on = [
    local_file.create_secureflow
  ]

  provisioner "local-exec" {
    command = " archy publish --forceUnlock --file architect-flows/EventOrchestrator_Secure_Flow.yaml --clientId $GENESYSCLOUD_OAUTHCLIENT_ID --clientSecret $GENESYSCLOUD_OAUTHCLIENT_SECRET --location $GENESYSCLOUD_ARCHY_REGION  --overwriteResultsFile --resultsFile results.json "
  }
}

resource "null_resource" "deploy_archy_flow_inboundcall" {
  depends_on = [
    null_resource.deploy_archy_flow_secureflow
  ]

  provisioner "local-exec" {
    command = "  archy publish --forceUnlock --file architect-flows/EventOrchestrator_Flow.yaml --clientId $GENESYSCLOUD_OAUTHCLIENT_ID --clientSecret $GENESYSCLOUD_OAUTHCLIENT_SECRET --location $GENESYSCLOUD_ARCHY_REGION --overwriteResultsFile --resultsFile results.json "
  }
}

resource "local_file" "create_workflow" {
    depends_on= [
      null_resource.deploy_archy_flow_inboundcall
    ]
    content     = templatefile("architect-flow-templates/EventOrchestrator_Workflow.tftpl", {dataAction = "${var.environment}-${var.saveData_prefix}"})
    filename = "architect-flows/EventOrchestrator_Workflow.yaml"
}

resource "null_resource" "deploy_archy_flow_workflow" {
  depends_on = [
    local_file.create_workflow
  ]

  provisioner "local-exec" {
    command = "  archy publish --forceUnlock --file architect-flows/EventOrchestrator_Workflow.yaml --clientId $GENESYSCLOUD_OAUTHCLIENT_ID --clientSecret $GENESYSCLOUD_OAUTHCLIENT_SECRET --location $GENESYSCLOUD_ARCHY_REGION  --overwriteResultsFile --resultsFile results.json "
  }
}