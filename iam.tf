resource "aws_iam_role" "replication" {
    name               = "s3_replication_role"
    assume_role_policy = jsonencode({
      Version   = "2012-10-17",
      Statement = [
        {
          Effect    = "Allow",
          Principal = {
            Service = "s3.amazonaws.com"
          },
          Action    = "sts:AssumeRole"
        }
      ]
    })

    # Add any additional configurations for the IAM role
  }