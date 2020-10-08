provider "aws" {
  region = "us-east-1"
}

module "build" {
  source = "../"

  project_name    = "build-${var.environment}"
  description     = "thing_that_build"
  environment     = var.environment
  pipeline_s3_arn = aws_s3_bucket.codepipeline_bucket.arn

  buildspec_path = ".aws/dev/build.yaml"
  build_image    = "node:14"
  build_timeout  = "10"

  environment_variable = [
    {
      name  = "ITS-DANGEROUS-TO-GO-ALONE-TAKE-THIS"
      value = "Cat"
    }
  ]
}


module "deploy" {
  source = "../"

  project_name    = "website-deploy-${var.environment}"
  description     = "thing_that_deploys_whatever_we_builded"
  environment     = var.environment
  pipeline_s3_arn = aws_s3_bucket.codepipeline_bucket.arn

  buildspec_path = ".aws/dev/deploy.yaml"
  build_image    = "aws/codebuild/standard:4.0"
  build_timeout  = "10"

  environment_variable = [
    {
      name  = "BUCKET_NAME"
      value = "Awesome-website"
    },
    {
      name  = "FRONTEND_CLOUDFRONT_ID"
      value = var.cf_distribution_id
    }
  ]
}

# add policy allowing user to deploy website (s3 and cloudfront)
resource "aws_iam_role_policy_attachment" "policy-website-to-deploy" {
  role       = module.deploy.role
  policy_arn = var.deploy_policy_arn
}

resource "aws_codepipeline" "codepipeline" {
  name     = "magical-pipeline-${var.environment}"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner                  = var.repo_owner
        Repo                   = var.repo_name
        Branch                 = var.repo_branch
        OAuthToken             = "PLACEHOLDER"
        "PollForSourceChanges" = "false"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = module.build.name
      }
    }
  }

  stage {
    name = "Deploy-front"

    action {
      name            = "Deploy-front"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ProjectName = module.deploy.name
      }
    }
  }
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "pipeline-awesome-bucket-for-example-${var.environment}"
  acl    = "private"
}

resource "aws_iam_role" "codepipeline_role" {
  name = "pipeline-${var.environment}-build-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "pipeline-${var.environment}-build-policy"
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_bucket.arn}",
        "${aws_s3_bucket.codepipeline_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
