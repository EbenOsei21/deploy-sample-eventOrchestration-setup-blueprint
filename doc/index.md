---
title: Utilize Event Orchestration
author: ebenezer.osei
indextype: blueprint
icon: blueprint
image: images/flowchart.png
category: 6
summary: |
  This Genesys Cloud Developer Blueprint demonstrates how to take advantage of the new process trigger feature to opimize your call flows. This solution utilizes process triggers to call a workflow whenever a call disconnects in a queue. The workflow then process participant data stored during the call.
---

This Genesys Cloud Developer Blueprint provides a simple example of how to deploy an event orchesration infrastructure using Terraform, CX as Code, and Archy.

This blueprint demonstrates how to:

- Deploy a simple event orchestration infrastructure using Terraform
- Setup a process automation trigger

![Event Orchestration flowchart](images/flowchart.png "Event Orchestration flowchart")

## Contents

- [Solution components](#solution-components "Goes to the Solutions components section")
- [Prerequisites](#prerequisites "Goes to the Prerequisites section")
- [Implementation steps](#implementation-steps "Goes to the Implementation steps section")
- [Additional resources](#additional-resources "Goes to the Additional resources section")

## Solution components

- **[Genesys Cloud](https://www.genesys.com/genesys-cloud "Opens the Genesys Cloud website")** - A suite of Genesys cloud services for enterprise-grade communications, collaboration, and contact center management. You create and manage OAuth clients in Genesys Cloud.
- **[Archy](https://developer.genesys.cloud/devapps/archy/ "Opens the Archy website")** - A Genesys Cloud Architect YAML processor that lets you create Architect flows from YAML files that you write.
- **[Terraform](https://www.terraform.io/ "Opens the Terraform website")** - An open-source infrastructure as code software tool that provides a consistent CLI workflow to manage hundreds of cloud services
- **[CX as Code ](https://developer.genesys.cloud/api/rest/CX-as-Code/ "Opens the CX as code website")** - A Genesys Cloud Terraform provider that provides a command line interface for declaring core Genesys Cloud objects.
- **[AWS Lambda](https://aws.amazon.com/lambda/ "Opens the AWS Lambda website")** - A serverless computing service for running code without creating or maintaining the underlying infrastructure.
- **[AWS S3](https://aws.amazon.com/s3/ "Opens the AWS S3 website")** - An object storage service offering industry-leading scalability, data availability, security, and performance.
- **[Node.js](https://nodejs.org/en/ "Opens the NodeJs website")** - An open-source, cross-platform JavaScript runtime environment.

## Prerequisites

### Specialized knowledge

- Administrator-level knowledge of Genesys Cloud
- AWS Cloud Practitioner-level knowledge of AWS IAM, Amazon Comprehend, Amazon API Gateway, AWS Lambda, AWS SDK for JavaScript, and the AWS CLI (Command Line Interface)
- Experience with Terraform

### Genesys Cloud account requirements

- A Genesys Cloud license. For more information, see [Genesys Cloud Pricing](https://www.genesys.com/pricing "Opens the Genesys Cloud pricing page") in the Genesys website.
- Master Admin role. For more information, see [Roles and permissions overview](https://help.mypurecloud.com/?p=24360 "Opens the Roles and permissions overview article") in the Genesys Cloud Resource Center.
- Archy. For more information, see [Welcome to Archy](/devapps/archy/ "Goes to the Welcome to Archy page").
- CX as Code. For more information, see [CX as Code](https://developer.genesys.cloud/api/rest/CX-as-Code/ "Opens the CX as Code page").

### AWS user account

- An administrator account with permissions to access the following services:
  - AWS Identity and Access Management (IAM)
  - AWS Lambda
  - AWS S3
- AWS credentials. For more information about setting up your AWS credentials on your local machine, see [About credential providers](https://docs.aws.amazon.com/sdkref/latest/guide/creds-config-files.html "Opens The shared config and credentials files") in AWS documentation.

### Third-party software

- Node.js version 14.0.0 or later. For more information, see [Node.js](https://nodejs.org/en/ "Opens Download Node.js") on the Node.js website.

- Terraform. For more information, see [Download Terraform](https://www.terraform.io/downloads) in the Terraform website.

## Implementation steps

- [Clone the repository that contains the project files](#clone-the-repository-that-contains-the-project-files "Goes to the Clone the repository containing the project files section")
- [Create a role for administering Process Automation Triggers](#create-a-role-for-administering-process-automation-triggers "Goes to the Create a role for administering Process Automation Triggers section")
- [Create an OAuth Client Credentials Token in Genesys Cloud](#create-an-oauth-client-credentials-token-in-genesys-cloud "Create an OAuth Client Credentials Token in Genesys Cloud section")
- [Define the environment variables](#define-the-environment-variables "Define the environment variables section")
- [Deploy the infrastructure](#deploy-the-application "Goes to the Build and deploy the infrastructure section")
- [Create a trigger to call workflow on call disconnect](#create-a-trigger-to-call-workflow-on-call-disconnect "Goes to the Create a trigger to call workflow on call disconnect section")

### Clone the repository that contains the project files

Clone the [deploy-sample-eventOrchestration-setup-blueprint](https://github.com/EbenOsei21/deploy-sample-eventOrchestration-setup-blueprint "Opens the deploy-sample-eventOrchestration-setup-blueprint") repository from GitHub to your local environment.

### Create a role for administering Process Automation Triggers

In Genesys Cloud, create a role that includes the `processautomation > trigger > All Permissions` permission. Assign this role to yourself so you can assign it to a client credential in the next step.

### Create an OAuth Client Credentials Token in Genesys Cloud

1. Create an OAuth client with the following settings:

- **Grant type**: Client Credentials
- **Role**: Configure it to use the role created in the previous step

2. Note the client ID. You will use this later to configure your project.

For more information, see [Create an OAuth client](https://help.mypurecloud.com/?p=188023 "Goes to the Create an OAuth client article") in the Genesys Cloud Resource Center.

### Define the environment variables

- **GENESYSCLOUD_OAUTHCLIENT_ID**: This is the Genesys Cloud client credential grant Id that CX as Code executes against.
- **GENESYSCLOUD_OAUTHCLIENT_SECRET**: This is the Genesys Cloud client credential secret that CX as Code executes against.
- **GENESYSCLOUD_REGION**: This is the Genesys Cloud region in which your organization is located.
- **GENESYSCLOUD_ARCHY_REGION**: This is the region where archy is going to deploy your infrastructure. eg: mypurecloud.com
- **AWS_ACCESS_KEY_ID**: This is the id that identifies your AWS account
- **AWS_SECRET_ACCESS_KEY**: This is the AWS secret that authorizes executions.

### Deploy the infrastructure

Open a terminal window and set the working directory to the `terraform` directory in the cloned repo. Then run the following:

```bash
terraform init
terraform apply --auto-approve
```

This should create and deploy the infrastructure. This includes 3 flows(an inbound call flow, a secure flow and a worflow), two lambdas(including the roles and policies that comes with it), data integrations, and data actions for the lambdas.

### Create a trigger to call workflow on call disconnect

Modify the values in the trigger.ts(located in workflow_trigger directory) after deploying. Use the values from your [OAuth client](#create-an-oauth-client-credentials-token-in-genesys-cloud "Goes to the Create an Implicit Grant OAuth client in Genesys Cloud section"):

```javascript
const CLIENT_ID = "<YOUR CLIENT ID GOES HERE>";
const CLIENT_SECRET = "<YOUR CLIENT SECRET GOES HERE>";
```

```javascript
  target: {
    type: "Workflow",
    id: "<YOUR WORKFLOW ID GOES HERE>",
  },
```

To find the workflow ID, navigate to the workflow in your Genesys Cloud admin account. The ID is the GUID inside of the URL after “flows/”.

For example, if the URL looks like this:
apps.region.com/architect/#/workflow/flows/917dcc65-5adb-4d61-a5c7-d63418ae7dd2/latest/task/e26cce88-0d5c-4d20-9e67-2d466c3a6630.

The workflow id will be `917dcc65-5adb-4d61-a5c7-d63418ae7dd2`

Save your changes and run (make sure your terminal working directory is set to the location of the trigger.ts file):

#TODO Can node execute typescript directly now. Regardless you need to have this execute within Terraform
```bash
node trigger.ts
```

## Additional resources

- [Deploy a simple IVR using Terraform, CX as Code, and Archy](/blueprints/simple-ivr-deploy-with-cx-as-code-blueprint/ "Goes Deploy a simple IVR using Terraform, CX as Code, and Archy blueprint") in the Genesys Cloud Developer Center
- [deploy-sample-eventOrchestration-setup-blueprint](https://github.com/EbenOsei21/deploy-sample-eventOrchestration-setup-blueprint) in Github
