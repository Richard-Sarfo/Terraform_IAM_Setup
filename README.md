# Terraform IAM Setup — Lab 1.1

Terraform implementation of AWS IAM roles and policies for a data engineering platform. Applies the **principle of least privilege**: each role gets only the permissions required for its specific function.

---

## Resources Created

| Resource | Type | Purpose |
|---|---|---|
| `DataEngineerRole` | IAM Role | Daily-work role for data engineers |
| `GlueServiceRole` | IAM Role | Assumed by AWS Glue jobs at runtime |
| `LambdaExecutionRole` | IAM Role | Assumed by Lambda functions at runtime |
| `RedshiftIAMRole` | IAM Role | Assumed by Redshift for S3 COPY/UNLOAD |
| `AnalystReadOnlyRole` | IAM Role | Read-only access for analysts and BI team |
| `DataLakeBucketAccessPolicy` | IAM Policy | Custom policy scoped to `data-lake-*` buckets with encryption enforcement |

### Role Permissions

**DataEngineerRole** — trusted by `ec2.amazonaws.com`
- `AmazonS3FullAccess`
- `AWSGlueConsoleFullAccess`
- `AmazonRedshiftFullAccess`
- `AmazonEMRFullAccessPolicy_v2`
- `AmazonKinesisFullAccess`
- `AWSLambda_FullAccess`
- `CloudWatchLogsFullAccess`

**GlueServiceRole** — trusted by `glue.amazonaws.com`
- `AWSGlueServiceRole`
- `AmazonS3FullAccess`
- `CloudWatchLogsFullAccess`
- `SecretsManagerReadWrite`

**LambdaExecutionRole** — trusted by `lambda.amazonaws.com`
- `AWSLambdaBasicExecutionRole`
- `AmazonS3FullAccess`
- `AmazonDynamoDBFullAccess`
- `AmazonKinesisFullAccess`
- `SecretsManagerReadWrite`

**RedshiftIAMRole** — trusted by `redshift.amazonaws.com`
- `AmazonS3FullAccess`
- `CloudWatchLogsFullAccess`

**AnalystReadOnlyRole** — trusted by `ec2.amazonaws.com`
- `AmazonAthenaFullAccess`
- `AmazonRedshiftReadOnlyAccess`
- `AmazonS3ReadOnlyAccess`

> **QuickSight:** Access is managed inside QuickSight's own user management UI, not via IAM managed policies.

### Custom Policy — DataLakeBucketAccessPolicy

Three-statement policy enforcing two compliance rules:

1. **ListDataLakeBucket** — allows `s3:ListBucket` and `s3:GetBucketLocation` on `arn:aws:s3:::data-lake-*` only.
2. **ReadWriteDataLakeObjects** — allows `s3:GetObject`, `s3:PutObject`, `s3:DeleteObject` on `data-lake-*/*` objects only.
3. **DenyUnencryptedUploads** — explicit `DENY` on `s3:PutObject` when the `x-amz-server-side-encryption` header is not `AES256`. DENY always overrides Allow regardless of other policies.

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.0
- AWS credentials with `IAMFullAccess` or `AdministratorAccess`

---

## Usage

**1. Clone the repo**
```bash
git clone https://github.com/Richard-Sarfo/Terraform_IAM_Setup.git
cd Terraform_IAM_Setup
```

**2. Configure AWS credentials**
```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

**3. Initialise, plan, and apply**
```bash
terraform init
terraform plan
terraform apply
```

**4. View outputs (role ARNs)**
```bash
terraform output
```

**5. Destroy all resources when done**
```bash
terraform destroy
```

---

## File Structure

```
.
├── main.tf                       # AWS provider configuration
├── variables.tf                  # Input variables (aws_region)
├── outputs.tf                    # Role and policy ARN outputs
├── iam_role_data_engineer.tf     # DataEngineerRole + attachments
├── iam_role_glue_service.tf      # GlueServiceRole + attachments
├── iam_role_lambda_execution.tf  # LambdaExecutionRole + attachments
├── iam_role_redshift.tf          # RedshiftIAMRole + attachments
├── iam_role_analyst.tf           # AnalystReadOnlyRole + attachments
├── iam_policy_data_lake.tf       # DataLakeBucketAccessPolicy
└── .terraform.lock.hcl           # Provider version lock
```

---

## Security Notes

- Rotate your AWS access keys after use — never commit credentials to git.
- IAM resources are free; there is no cost to keeping these roles.
- Do not delete roles until Labs 1.2 and 1.3 are complete — they depend on them.
