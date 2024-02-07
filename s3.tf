resource "aws_s3_bucket" "s3" {
  for_each  = var.s3_config
  bucket    = each.key

  #Ensure a lifecycle configuration is applied
  lifecycle_rule {
    id      = "log_expiration"
    enabled = true

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }

  replication_configuration {
    role = aws_iam_role.replication.arn

    rules {
      id     = "foobar"
      prefix = "foo"
      status = "Enabled"

      destination {
        bucket        = var.bucket 
        storage_class = "STANDARD"
      }
    }
  }



  tags      = merge({ "Name" = each.key }, var.tags)
}


 

resource "aws_s3_bucket_public_access_block" "bucket_public_policy" {
  for_each  = var.s3_config
  bucket = aws_s3_bucket.s3[each.key].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  for_each  = var.s3_config
  bucket = aws_s3_bucket.s3[each.key].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "policy" {
 for_each  = var.s3_config
 bucket = aws_s3_bucket.s3[each.key].id
 policy = each.value.bucket_policy
}

resource "aws_s3_bucket_logging" "example" {
  for_each       = var.s3_config
  bucket         = aws_s3_bucket.s3[each.key].id
  target_bucket  = aws_s3_bucket.log_bucket.id
  target_prefix  = "log/"
}



resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption_config" {
  for_each  = var.s3_config
  bucket = aws_s3_bucket.s3[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
      #sse_algorithm = "AES256"
    }
  }
}




resource "aws_kms_key" "mykey" {
  description             = "Your KMS Key Description"
  deletion_window_in_days = 10
  enable_key_rotation = true
}

resource "aws_kms_key_policy" "s3_kms_key" {
    key_id = aws_kms_key.mykey.id
    policy = jsonencode(
{
  "Version": "2012-10-17",
  "Id": "key-default-1",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::471112942117:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow access for key administrators",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::471112942117:user/admin-username"
      },
      "Action": [
        "kms:Create*",
        "kms:Describe*",
        "kms:Enable*",
        "kms:List*",
        "kms:Put*",
        "kms:Update*",
        "kms:Revoke*",
        "kms:Disable*",
        "kms:Get*",
        "kms:Delete*",
        "kms:TagResource",
        "kms:UntagResource",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Allow use of the key",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::471112942117:user/user1@example.com"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Allow attachment of persistent resources",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::471112942117:user/user2@example.com"
      },
      "Action": [
        "kms:CreateGrant",
        "kms:ListGrants",
        "kms:RevokeGrant"
      ],
      "Resource": "*",
      "Condition": {
        "Bool": {
          "kms:GrantIsForAWSResource": "true"
        }
      }
    }
  ]
})
}


# resource "aws_sns_topic" "topic" {
#   for_each = var.s3_config
#   name   = "s3-event-notification-topic"
#   policy = data.aws_iam_policy_document.topic[each.key].json
#   kms_master_key_id = "alias/aws/sns"
# }


resource "aws_s3_bucket_notification" "bucket_notification" {
  for_each = var.s3_config
  bucket = aws_s3_bucket.s3[each.key].id
 
  lambda_function {
    lambda_function_arn = var.lambda_function_arn
    events             = ["s3:ObjectCreated:*"]
  }
}








