# Boldare Terraform Modules

This repository contains collection of higher level modules that simplify infrastructure
setup for teams with little to no operator's assistance.

## Usage

If this repository contains a module you'd like to use, check out it's `README.md` and `example` directory.

To include a module directly from this repository, use `github.com/boldare/terraform-modules//modules/<module-name>?ref=<tag-or-branch>` as `source` in Terraform module definition. For example:

```tf
module "namespace" {
  source = "github.com/boldare/terraform-modules//modules/aws-eks-namespace?ref=v0.1.0"

  namespace = local.name
  iam_path  = local.iam_path

  administrators              = var.administrators
  administrators_iam_policies = {}

  developers              = var.developers
  developers_iam_policies = {}
}
```

## Modules Summary

| Module | Description |
|--------|-------------|
| [`aws-bastion-instance`](./modules/aws-bastion-instance) | Creates EC2 instance with public IP within a specified VPC. |
| [`aws-cert-lambda`](./modules/aws-cert-lambda) | Provides automatic refresh of Let's Encrypt certificates, that are stored on S3 bucket. Use only if ACM doesn't fit your needs. |
| [`aws-cognito`](./modules/aws-cognito) | Creates Cognito User Pool with necessary IAM policies. |
| [`aws-datadog-integration`](./modules/aws-datadog-integration) | Creates Lambda, role & policies necessary to run full Datadog monitoring for AWS account. |
| [`aws-ecs-service`](./modules/aws-ecs-service) | Creates ECS service, task, ECR (Docker repository) and binds the service to existing application load balancer. |
| [`aws-ecs-service-permissions`](./modules/aws-ecs-service-permissions) | Manages IAM permissions for ECS service and attaches a policy to read specific secrets from AWS Secret Manager. |
| [`aws-eks-cluster`](./modules/aws-eks-cluster) | Creates managed Kubernetes cluster using `terraform-aws-modules/terraform-aws-eks` and attaches policies for autoscaling, load-balancing & DNS. |
| [`aws-eks-iam-role-group`](./modules/aws-eks-iam-role-group) | Defines IAM-EKS binding, allowing IAM group users to perform specific set of operations on EKS cluster. |
| [`aws-eks-namespace`](./modules/aws-eks-namespace) | Creates a namespace for Kubernetes project. Defines binding for IAM roles to allow access to EKS. Provides IAM policies that allow access to S3 buckets & ECR repositories prefixed by namespace name. |
| [`aws-frontend`](./modules/aws-frontend) | Creates S3 bucket + CloudFormation + Route53 + Lambda@Edge setup allowing for nearly single-module SPA frontend app deployment. |
| [`aws-generate-cert`](./modules/aws-generate-cert) | Creates ssl certificate for domain in route53 zone specified. | 
| [`aws-iam-user-group`](./modules/aws-iam-user-group) | Creates IAM user group, attaches users and policies to it. |
| [`aws-kms-key`](./modules/aws-kms-key) | Creates KMS key with an alias and creates Key policy that allows to configure access using IAM. |
| [`aws-mfa-policy`](./modules/aws-mfa-policy) | Creates Multi-Factor Authorization policy that can be attached to global user groups. |
| [`aws-one-sm-to-many-ssm-secrets`](./modules/aws-one-sm-to-many-ssm-secrets) | Creates SSM secrets from one Security Manager secret. |
| [`aws-s3-authorized-keys`](./modules/aws-s3-authorized-keys) | Stores SSH keys on S3 bucket providing a script for EC2 instances to pull synchronize those keys with bucket. |
| [`aws-s3-bucket`](modules/aws-s3-bucket) | Creates S3 bucket. Allows for a couple of simplifications. |
| [`aws-users`](./modules/aws-users) | Creates a list of users within a specified IAM path. |
| [`vault-consul-cluster`](./modules/vault-consul-cluster) | Creates Vault & Consul cluster running on EC2 instances. |
| [`vault-gitlab-auth`](./modules/vault-gitlab-auth) | Creates GitLab authentication backend in Vault. |
| [`vault-gitlab-user`](./modules/vault-gitlab-user) | Binds GitLab user with Vault entity. |
| [`vault-group`](./modules/vault-group) | Creates a "namespace" for storing secrets in KV store in Vault. Supports multiple environments with read-only & read-write permissions. |


## Contributing

If you created a module that fulfills your specific needs, feel free to create Pull Request
which adds it to the repository.

Found a bug? Need a feature? [Create an issue](https://github.com/boldare/terraform-modules/issues/new) describing 
what happens, providing context information and desired output.

## License

[MIT License, Copyright (c) 2020 Boldare](LICENSE)


