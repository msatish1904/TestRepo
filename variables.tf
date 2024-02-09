variable "region"{
  description = "Location of S3"
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = "AKIAW3MEFAISQDWECBAE5Z"
}

variable "aws_secret_key" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = "QL2KFGCd9kFPrezoZiR+mfummFxS8oiiViECbathwsM"
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

