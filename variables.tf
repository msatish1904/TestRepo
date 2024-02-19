variable "region"{
  description = "Location of S3"
  type        = string
  default     = "us-east-1"
}

variable "s3_config" {
  description = "details of the s3 configuration"
  type = map(object({
    bucket_versioning_configuration_status = string
#    bucket_policy                          = string
  }))
  
}

variable "iam_role_path" {
  description = "Path to the role"
  type        = string
  default     = "/"
}

variable "aws_managed_policy" {
  description = "The ARN of the policy we want to apply"
  type        = list(string)
  default     = [""]
}

