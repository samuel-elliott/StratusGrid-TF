variable "s3_artifact_bucket" {  
  type        = string  
  default = "sam-elliott-stratusgrid-s3-bucket"
  description = "Change this variable to change the name of the S3 bucket."
}

variable "region_name" {  
  type        = string  
  default     = "us-east-2"
}

variable "environment" {
  type = string
  default = "Production"
}

# The name of the Codepipeline
variable "codepipeline_name" {
  type = string
  default = "sam-elliott-stratusgrid-codepipeline"
}

# The name of the AWS KMS key to use for S3 bucket encryption at rest.
#variable "s3_kms_key" {
#  type = string
#  default = "sam-elliott-s3-kms-key"
#}

# S3 Bucket to be used for S3 Backend storage of Terraform.
variable "s3_backend" {
  type = string
  default = "sam-elliott-stratusgrid-s3-backend"
}

variable "dynamodb_table_lock" {
  type = string
  default = "sam-elliott-stratusgrid-dynamodb-lock"
}

variable "s3_origin_id" {
  type = string
  default = "sam-elliott-stratusgrid-s3-bucket-origin-id"
}

variable "codepipeline_service_role" {
  type = string
  default = "sam-elliott-codepipeline-service-role"
}

variable "CodePipeline_IAM_Policy" {
  type = string
  default = "sam-elliott-codepipeline-iam-policy"
}

variable "Webhook_Secret" {
  type = string
  default = "&KU&mEsH3&^W&kYP2!QicDH24YxafEgR!SvdY2dQ*Phs3UF#*npZf4j9RH8Sh^Kk"
}

# GitHub -> Settings -> Developer settings -> Personal Access Tokens -> "StratusGrid Terraform project"
variable "GitHub_Token" {
  type = string
  default = "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"
}
  
variable "GitHub_Repo" {
  type = string
  default = "StratusGrid"
}

variable "GitHub_Branch" {
  type = string
  default = "master"
}

variable "GitHub_Owner" {
  type = string
  default = "samuel-elliott"
}

variable "CloudFront_Domain_Name" {
  type = string
  default = "Sam-Elliott-StratusGrid.cloudfront.net"
}
