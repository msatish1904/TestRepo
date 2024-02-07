output "id" {
    description = "Name of the s3 bucket"
    value = {for k,v in aws_s3_bucket.s3: k=>v.id}
}

output "arn" {
    description = "ARN of the s3 bucket"
    value = {for k,v in aws_s3_bucket.s3: k=>v.arn}
}
