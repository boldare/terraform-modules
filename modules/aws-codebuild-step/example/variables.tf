variable "environment" {
  type        = string
  description = "Environment you are working on (dev, prod)."
}

variable "repo_owner" {
  description = "Organization/username owning repository on github."
}

variable "repo_name" {
  description = "Name of repository."
}

variable "repo_branch" {
  description = "Branch from repository used in build"
}

variable "cf_distribution_id" {
  description = "Cloudfront distribution id for cache invalidation"
}

variable "deploy_policy_arn" {
  description = "Policy allowing to deploy files for website"
}
