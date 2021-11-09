# SimpleCRMAPI
A simple CRM API that manages operations and allows users to list, create, update, and delete customer entries.

## Infrastructure
![ alt text for screen readers](https://github.com/gowithkk/SimpleCRMAPI/blob/main/Image/SimpleCRMAPI-Architecture.png) 

## Summary
This SimpleCRMAPI creates the following resources in AWS using Terraform. When executing terraform deploy:
* SimpleCRMAPI creates
     * Custom IAM policy and roles
     * API Gateway with a single resource "/Customers" and HTTP Methods
     * 4 Lambda functions that support GET, POST, DELETE, and PATCH
     * A DynamoDB table called SimpleCRM
     * CloudWatch Logs for Lambda functions and API Gateway, and Metric Alarms for Lambda functions and DynamoDB table
     * S3 bucket
* SimpleCRMAPI also zips python source codes and uploads zip files to S3 bucket in support of Lambda functions.

Once deployment is completed, the following display as outputs:
* S3 bucket name
* API endpoint URL
     * e.g. https://lqk0ux4xmg.execute-api.ap-southeast-2.amazonaws.com/dev/Customers
     * Use CURL or Postman as your favour to invoke the returned API endpint URL.

## Usage

Please ensure you have Terraform, AWS CLI and, [Admin Profile](https://docs.aws.amazon.com/polly/latest/dg/setup-aws-cli.html) configured before running SimpleCRMAPI. Your AWS admin profile should have certain permissions to create IAM role and policy, API Gateway, Lambda, DynamoDB, CloudWatch Log and Alarms.

To run this SimpleCRMAPI please execute:

```
git clone https://github.com/gowithkk/SimpleCRMAPI.git
```

```bash
cd SimpleCRMAPI
terraform workspace new dev
terraform init
terraform plan --var-file="dev.tfvars"
terraform apply --var-file="dev.tfvars"
```

Note that this project may create resources that cost money. Run `terraform destroy --var-file="dev.tfvars"` when you don't need these resources.

## Documentation for API Endpoints

All URIs are relative to SimpleCRM_apigw-dev-apigateway.yaml

HTTP request | Request Body | Response Body | Description
------------ | ------------- | ------------- | ------------- 
**GET** /Customers  | None | Array of Customers | Lists all the customers' info, including customer id as id, first name as fisrtName, last name as lastName, and address.
**POST** /Customers | Customers | None | Adds a new customer
**PATCH** /Customers | Customers | None | Updates an existing customer&#39;s info
**DELETE** /Customers | ID | None |  Deletes an existing customer by its ID

Exmaple Value
```json
{
  "id": "string",
  "firstName": "string",
  "lastName": "string",
  "address": "string"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.48.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | >= 2.2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.2.0 |

## Assumptions
 * User authentication is not required. API Gateway in this project has been set to No Auth.
 * Each customer has a unique customer id to avoid conflicts. User "id" must be included in the HTTP body when creating, updating, and deleting customer entries in DynamoDB.

 ## Specifications
 * Default region is set to Sydney (ap-southeast-2). Region and other attributes can be changed in dev.tfvars as required.
 * Capacity mode of the DynamoDB table in this project has been set to On-demand. This is to save cost by paying for the actual reads and writes the application performs. In this mode, auto-scaling is enabled by default. 
 * Terraform state is managed locally as this requires a separate dynamoDB table and S3 bucket pre-defined. If you plan to manage state using state lock with S3 and dynamoDB, feel free to uncomment line 19~26 in main.tf and change the values to match your DB name and S3 bucket name.
 * Security Consideration
     * VPC
          * For security concerns, having lambda functions deployed in a VPC is recommended. However, due to the simplicity of this project, no VPC is created and utilized. Reasons are as below: 
               * In this project, interactions between Lambda functions, API Gateway, and DynamoDB table are controlled and protected by IAM roles.
               * Only necessary permissions have been assigned to AWS resources for security reasons.
               * For future development, if the Lambda functions need to access other resources, such as EC2 instances, RDS instances, or other AWS resources running inside a VPC, then it is recommended to place Lambda functions inside of a VPC. Access to DynamoDB, resources in other VPC, or public internet can be granted by a VPC endpoint or a NAT Gateway.
     * IAM
          * API Gateway
               * api_gateway_cloudwatch_global role is assigned to allow API Gateway to create log group and put logs to CloudWatch.
               * Each API method has been given permissions to invoke relevant Lambda functions.
          * Lambda
               * A custom role called serverless_lambda is assigned to Lambda. This role is to allow the following actions to resources:
                    * Write CloudWatch Logs 
                    * Read & Write DynamoDB 
                    * Read & Write S3 Objects
     * Logging
          * API Gateway
               * Logging level for API Gateway has been set to INFO and all relevant logs can be found under CloudWatch Log Groups with the name of API-Gateway-Execution-Logs.
          * Lambda
               * CloudWatch generates a log group for Lambda upon lambda function execution. i.e. "/aws/lambda/create" for lambda function "create".
          * DynamoDB
               * No logging is set for DynamoDB in this case. However, CloudTrail can be enabled to record any events on a DyanmoDB table.
     * Alarms
          * DynamoDB
               * CloudWatch alarms when consumed read capacity units of the DynamoDB table reach a certain point (threshold is now set to 1000). Please note that this is an approx number and can be changed as required. Other DynamoDB metrics can be found in [AWS Doc](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/metrics-dimensions.html).
          * Lambda
               * CloudWatch alarms when a single error occurs on any lambda functions.


## Justification
* DynamoDB is a NoSQL database that is scalable, cost-effective, serverless, and easy to manage. A CRM system like this project prefers to use a relational database such as Amazon RDS or Amazon Aurora. However, managing a relational database is more complicated in nature. Also, Amazon RDS only supports vertical auto-scaling. Since we only need one table for customers in this case, DynamoDB was selected due to its simplicity. 
* Alternatively, API can be deployed to Elastic Beanstalk or EC2 other than Lambda. Elastic Beanstalk and Lambda support auto-scaling by default, while EC2 requires additional configuration to enable auto-scaling. Elastic Beanstalk is a PaaS and is necessary for running a service that listens on an Internet port (other than HTTP). Developers can manage some aspects of the infrastructure while EC2 is highly customizable. However, with the customization levels increasing, complexity will follow. On the other hand, Lambda is serverless, lightweight, and event-driven. It lets code or events invoke functions. With Lambda, developers do not have to deal with their code's environment. Also, its free tier includes one million free requests per month. Lambda is the cheapest and the most appropriate solution among other options.
* API Gateway vs Application Load Balancer. Application Load Balancer (ALB) is more cost-effective compared to a gateway and is better suited to applications requiring high-throughput, while API Gateway has a limit of 10,000 RPS (requests per second). Both API Gateway and ALB are AWS-managed services that support path-based routing. API Gateway supports features not available in ALB, such as Token-based authentication, integration with IAM, and storing access logs in CloudWatch.

## Author
Kai Liu | liuky008@gmail.com
