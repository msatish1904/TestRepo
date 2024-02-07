variable "region"{
  description = "Location of S3"
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = "AKIAW3MEFAISQDWECE5Z"
}

variable "aws_secret_key" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = "QL2KFGCd9kFPrezoZiR+mfummFxS8oiiViEthwsM"
}
variable "s3_config" {
  description = "details of the s3 configuration"
  type = map(object({
    bucket_versioning_configuration_status = string
#    bucket_policy                          = string
  }))
  
}


variable "tags" {
  description = "Any tags that should be present on the resources"
  type        = map(string)
  default     = {}
}



variable "iam_role_name" {
  description = "The name of the role. If omitted, Terraform will assign a random, unique name."
  type = string
  default = ""
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

variable "iam_policy_name" {
  description = "The name of the policy. If omitted, Terraform will assign a random, unique name."
  type = string
  default = ""
}

variable "iam_policy_path" {
  description = "Path in which to create the policy"
  type        = string
  default     = "/"
}

variable "iam_policy_description" {
  description = "Description of the IAM policy."
  type        = string
  default     =  ""
}

variable "iam_policy_definitions" {
  description = "The policy document. This is a JSON formatted string"
  type        = string
  default     = ""
}

variable "iam_role_definitions" {
  description = "Policy that grants an entity permission to assume the role."
  type = string
  default = ""
}

variable "force_detach_policies" {
  description = "Whether to force detaching any policies the role has before destroying it"
  type        = bool
  validation {
    condition     = contains([false, true], var.force_detach_policies)
    error_message = "Argument 'force_detach_policies' must be one of 'false', 'true'"
  }
  default     = false
}

variable "iam_role_description" {
  description = "Description of the IAM role."
  type        = string
  default     = ""
}

variable "permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the role."
  type        = string
  default     = ""
}

variable "max_session_duration" {
  description = "Maximum session duration (in seconds) that we want to set for the specified role."
  type    = string
  default = "3600"
}


variable "lambda_function_arn" {
  description = "ARN of Lambda function"
  type        = string
}

variable "bucket" {
  type = string
  
}