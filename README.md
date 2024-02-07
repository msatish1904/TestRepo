## Introduction

Terraform module which creates S3 resources on your AWS account.

## Description

Provision [S3 Bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)

This module provides recommended settings:

- Enable Bucket versioning
- Enable server side encryption
- Disable public access


## Installation

```shell

git clone https://git.altimetrik.com/bitbucket/scm/cloudauto/tf-mod-s3.git
cd tf-mod-s3

Update with required and appropriate details in the respective field 

```
## To run this example you need to execute below

To initialize the Terraform directory, run the following command:
```hcl
terraform init
```
To generate an execution plan, run the following command:
```hcl
terraform plan
```
To apply the execution plan, run the following command:
```hcl
terraform apply
```
Note that this example may create resources which cost money. Run ``` terraform destroy``` when you don't need these resources.

Requirements

| Name      | Version    |
| --------- |------------|
| terraform | `>= 1.4.6` |
# Inputs

| Name                                  | Description                                                          | Type           | Default     | Required |
|---------------------------------------|----------------------------------------------------------------------|----------------|-------------|:--------:|
| region                                | Location of s3 bucket instance                                       | `string`       | "us-east-1" |   yes    |
| s3_buckets                            | The name of the s3 bucket to be created                              | `list[string]` | ""          |   yes    |
| bucket_versioning_configuration_status | The versioning of the bucket will be setup to be enabled or disabled | `string`       | ""          |   yes    |
| lambda_function_arn                                | ARN of lambda function for event notification                                       | `string`       | "" |   yes    |
| role                                | IAM role arn for replication configuration                                       | `string`       | "" |   yes    |
| bucket                                | Destination bucket arn                                       | `string`       | "" |   yes    |
| storage_class                                | Type of storage class                                       | `string`       | "" |   yes    |
                          

# Example of module usage (tfvars.tf)

`To create multiple S3 buckets`
```hcl
module "s3" {
  source = "git::https://git.altimetrik.com/bitbucket/scm/cloudauto/tf-mod-s3.git?ref=master"
  region = "us-east-1"
  lambda_function_arn = "arn:aws:lambda:us-east-1:xxxxxxxxx:function:xxxxxxxx"
  bucket        = "arn:aws:s3:::test-12124321"


  s3_config = {
    "poc-cloudops-1" = {
      bucket_versioning_configuration_status = "Enabled"
      replication_configuration = {
        role = "arn:aws:iam::xxxxxxxxx:role/xxxxxxxxx"
        rules = [
          {
            id       = "something-with-kms-and-filter"
            prefix   = "foo"
            status   = "Enabled"
            destination = {
              
              storage_class = "STANDARD"
            }
          }
        ]
      }


      lifecycle_rule = [
        {
          id      = "log"
          enabled = true

          filter = {
            tags = {
              some    = "value"
              another = "value2"
            }
          }

          transition = [
            {
              days          = 30
              storage_class = "ONEZONE_IA"
            },
            {
              days          = 60
              storage_class = "GLACIER"
            },
          ]
        }
      ]
    }

    "poc-cloudops-2" = {
      bucket_versioning_configuration_status = "Enabled"
      replication_configuration = {
        role = "arn:aws:iam::xxxxxxxxx:role/xxxxxxxxx"
        rules = [
          {
            id       = "something-with-kms-and-filter"
            prefix   = "foo"
            status   = "Enabled"
            destination = {
              
              storage_class = "STANDARD"
            }
          }
        ]
      }



      lifecycle_rule = [
        {
          id      = "log"
          enabled = true

          filter = {
            tags = {
              some    = "value"
              another = "value2"
            }
          }

          transition = [
            {
              days          = 30
              storage_class = "ONEZONE_IA"
            },
            {
              days          = 60
              storage_class = "GLACIER"
            },
          ]
        }
      ]
    }
  }
  
  tags = {
    "Project"     = "" ## The name of the project that the resource is used for.
    "Application" = "" ## The name of the application or feature of that the resource belongs to.
    "Owner"       = "" ## The email address of the person or team that owns the resource (@altimetrik.com)
    "Environment" = "" ## The environment in which the resource is used. Allowed values are "Test", "QA", "Staging", "Development", "Non-Prod", "Sandbox", "UAT", "Prod"
  }
}

terraform {
  backend "s3" {
    bucket         = ""
    key            = ""
    region         = ""
    encrypt        = "true"
    dynamodb_table = ""
  }
}
```


## Example outputs.tf to export the outputs

```hcl
ouput "id" {
    description = "Name of the s3 bucket"
    value = module.s3.id
}

ouput "arn" {
    description = "ARN of the s3 bucket"
    value = module.s3.arn
}

```

## Outputs


| Name | Description                       |
|------|-----------------------------------|
| id   | The name of the s3 bucket created |
| arn  | The ARN of the s3 bucket created  |




| Version    | Description |
| --------- | ------- |
| 1.0.0     | Initial version of s3 resources|
-----------------------------------------
