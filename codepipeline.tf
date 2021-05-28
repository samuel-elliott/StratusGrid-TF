resource "aws_codepipeline" "github" {
  name     = "github-pipeline"
  role_arn = aws_iam_role.AWSCodePipelineServiceRole.arn

  artifact_store {
    location = var.s3_artifact_bucket
    type     = "S3"

    encryption_key {
      id   = aws_kms_key.s3_bucket_cmk_key.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider 		= "GitHub"
      # Produces some bizarre error.
# Error: [ERROR] Error updating CodePipeline (github-pipeline): ValidationException: 1 validation error detected: Value at 'pipeline.stages.1.member.actions.1.member.actionTypeId.provider' failed to satisfy constraint: Member must satisfy regular expression pattern: [0-9A-Za-z_-]+
	  #provider         = "integrations/github"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        Owner  = var.GitHub_Owner
        Repo   = var.GitHub_Repo
        Branch = "master"
	    OAuthToken = var.GitHub_Token
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["SourceArtifact"]
      version         = "1"

      configuration = {
        BucketName = var.s3_artifact_bucket
        Extract = "true"
      }
    }
  }
}

# A shared secret between GitHub and AWS that allows AWS
# CodePipeline to authenticate the request came from GitHub.
# Would probably be better to pull this from the environment
# or something like SSM Parameter Store.
#locals {
#  webhook_secret = var.Webhook_secret
#}

resource "aws_codepipeline_webhook" "StratusGrid" {
  name            = "StratusGrid"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.github.name

  authentication_configuration {
    secret_token = var.Webhook_Secret
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}

resource "github_repository" "StratusGrid" {
  name         = "StratusGrid"
  description  = "StratusGrid"
  homepage_url = "https://github.com/samuel-elliott/StratusGrid"

  # Getting warning about this despite it being in official Terraform documentation example.
  # FILE BUG REPORT TO GET DOCUMENTATION UPDATED!
#  private = false 
  visibility = "public"
}

# Wire the CodePipeline webhook into a GitHub repository.
resource "github_repository_webhook" "StratusGrid" {
  repository = github_repository.StratusGrid.name

  configuration {
    url          = aws_codepipeline_webhook.StratusGrid.url
    content_type = "json"
    insecure_ssl = true
    secret       = var.Webhook_Secret
  }

  events = ["push"]
}
