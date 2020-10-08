variable "project_name" {
  type        = string
  description = "Name of that project used as name of codebuild step"
}

variable "description" {
  type        = string
  description = "Description of that codebuild step visible on AWS panel"
}

variable "environment" {
  type        = string
  default     = "None"
  description = "Name of environment which is added to tag"
}

variable "buildspec_path" {
  type        = string
  description = "Path inside artifacts from previous step to get buildspec file"
}

variable "build_image" {
  type        = string
  description = "Name of docker/aws image used as system used on building"
}

variable "build_timeout" {
  type        = string
  default     = "60"
  description = "Time in minutes that build is going to be allowed to run"
}

variable "pipeline_s3_arn" {
  type        = string
  description = "Arn of S3 where artifacts are going to be stored to "
}

variable "environment_variable" {
  type        = list(map(string))
  default     = []
  description = "list of environment variables set inside build container"
}
