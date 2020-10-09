variable "project_name" {
  type        = string
  description = "Name of that project used as name of codebuild step"
}

variable "description" {
  type        = string
  description = "Description of that codebuild step visible on AWS panel"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of tags set on codebuild project"
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

variable "artifact_s3_arn" {
  type        = string
  description = "Arn of S3 where artifacts are going to be stored to"
}

variable "environment_variables" {
  type        = list(map(string))
  default     = []
  description = "list of environment variables set inside build container"
}

variable "compute_size" {
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
  description = "Compute resources the build project will use"
}

variable "compute_type" {
  type        = string
  default     = "LINUX_CONTAINER"
  description = "The type of build environment to use for related builds (linux, gpu, windows, arm)"
}
