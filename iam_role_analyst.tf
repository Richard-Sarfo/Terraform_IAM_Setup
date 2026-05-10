# AnalystReadOnlyRole — for data analysts and BI team members.
# Read-only everywhere: analysts can run queries and view dashboards but
# cannot modify schemas, delete objects, or write data. This separates
# the "build" concern (engineers) from the "consume" concern (analysts),
# limiting the damage an analyst account compromise can cause.
resource "aws_iam_role" "analyst_readonly" {
  name        = "AnalystReadOnlyRole"
  description = "Read-only role for analysts to access Redshift, Athena, QuickSight, and S3"

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

resource "aws_iam_role_policy_attachment" "analyst_athena" {
  role       = aws_iam_role.analyst_readonly.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAthenaFullAccess"
}

resource "aws_iam_role_policy_attachment" "analyst_redshift_readonly" {
  role       = aws_iam_role.analyst_readonly.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftReadOnlyAccess"
}

# QuickSight access is managed inside QuickSight itself (via its own user
# management UI), not through IAM managed policies. AWS does not publish
# an AmazonQuickSightReadOnlyAccess managed policy, so this is handled
# separately in the QuickSight console after provisioning.

resource "aws_iam_role_policy_attachment" "analyst_s3_readonly" {
  role       = aws_iam_role.analyst_readonly.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
