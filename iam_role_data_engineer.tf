# DataEngineerRole — the daily-work role for data engineers.
# Broad access across data platform services (S3, Glue, Redshift, EMR,
# Kinesis, Lambda, CloudWatch). Cannot delete Redshift clusters, access
# billing, or delete databases (those require additional privilege escalation).
resource "aws_iam_role" "data_engineer" {
  name        = "DataEngineerRole"
  description = "Role for data engineers to access S3, Glue, Redshift, EMR, Kinesis, Lambda, and CloudWatch"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEC2Assumption"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "data_engineer_s3" {
  role       = aws_iam_role.data_engineer.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "data_engineer_glue" {
  role       = aws_iam_role.data_engineer.name
  policy_arn = "arn:aws:iam::aws:policy/AWSGlueFullAccess"
}

resource "aws_iam_role_policy_attachment" "data_engineer_redshift" {
  role       = aws_iam_role.data_engineer.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftFullAccess"
}

resource "aws_iam_role_policy_attachment" "data_engineer_emr" {
  role       = aws_iam_role.data_engineer.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEMRFullAccessPolicy_v2"
}

resource "aws_iam_role_policy_attachment" "data_engineer_kinesis" {
  role       = aws_iam_role.data_engineer.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFullAccess"
}

resource "aws_iam_role_policy_attachment" "data_engineer_lambda" {
  role       = aws_iam_role.data_engineer.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaFullAccess"
}

resource "aws_iam_role_policy_attachment" "data_engineer_cloudwatch" {
  role       = aws_iam_role.data_engineer.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
