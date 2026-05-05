# RedshiftIAMRole — assumed by the Redshift cluster itself.
# Required so Redshift can execute COPY FROM 's3://bucket/data' commands.
# Read-only S3 access: Redshift needs to read data files, not manage buckets.
resource "aws_iam_role" "redshift" {
  name        = "RedshiftIAMRole"
  description = "Service role for Redshift to read/write to S3 and write CloudWatch Logs"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowRedshiftAssumption"
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "redshift_s3" {
  role       = aws_iam_role.redshift.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "redshift_cloudwatch" {
  role       = aws_iam_role.redshift.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
