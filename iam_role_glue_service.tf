# GlueServiceRole — assumed by the Glue SERVICE, not by people.
# When a Glue job runs, AWS uses this role to determine what the job
# can access. Keeping it separate limits blast radius if a job is
# exploited: attacker gets S3 + logs only, not the full engineer role.
resource "aws_iam_role" "glue_service" {
  name        = "GlueServiceRole"
  description = "Service role for AWS Glue jobs to access S3, CloudWatch Logs, and Secrets Manager"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowGlueAssumption"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "glue_service_base" {
  role       = aws_iam_role.glue_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy_attachment" "glue_service_s3" {
  role       = aws_iam_role.glue_service.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "glue_service_cloudwatch" {
  role       = aws_iam_role.glue_service.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "glue_service_secrets" {
  role       = aws_iam_role.glue_service.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}
