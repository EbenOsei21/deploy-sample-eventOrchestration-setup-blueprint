# deploy-sample-eventOrchestration-setup-blueprint

This Genesys Cloud Developer Blueprint provides a simple example of how to deploy an Event Orchestration Infrastructure using Terraform, CX as Code, and Archy. In the proess of deploying the infrastructure, Terraform will deploy all the required AWS resources, genesys cloud resources including data actions and integrations, architect flows including call flows and a workflow, and finally run a python script to create a process trigger which is very crutial to the Event Orchestration Infrastructure. The process trigger enables you to define events or conditons that will enable your workflow to be executed in response to defined events.

![Event Orchestration flowchart](/blueprint/images/blueprint.png "Event Orchestration flowchart")
