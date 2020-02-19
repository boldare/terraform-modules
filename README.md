# Boldare Terraform Modules

This repository contains collection of higher level modules that simplify infrastructure
setup for teams with little to no operator's assistance.

## Usage

If this repository contains a module you'd like to use, check out it's `README.md` and `example` directory.

To include a module directly from this repository, use `github.com/boldare/terraform-modules//modules/<module-name>?ref=<tag-or-branch>` as `source` in Terraform module definition. For example:

```hcl-terraform
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
| [`aws-iam-user-group`](./modules/aws-iam-user-group) |  |
| [`aws-kms-key`](./modules/aws-kms-key) |  |
| [`aws-mfa-policy`](./modules/aws-mfa-policy) |  |
| [`aws-route53-zone-with-cert`](./modules/aws-route53-zone-with-cert) |  |
| [`aws-s3-authorized-keys`](./modules/aws-s3-authorized-keys) |  |
| [`aws-s3-bucket-private`](./modules/aws-s3-bucket-private) |  |
| [`aws-users`](./modules/aws-users) |  |
| [`vault-consul-cluster`](./modules/vault-consul-cluster) |  |
| [`vault-gitlab-auth`](./modules/vault-gitlab-auth) |  |
| [`vault-gitlab-user`](./modules/vault-gitlab-user) |  |
| [`vault-group`](./modules/vault-group) |  |


## Contributing

If you created a module that fulfills your specific needs, feel free to create Pull Request
which adds it to the repository.

Found a bug? Need a feature? [Create an issue](https://github.com/boldare/terraform-modules/issues/new) describing 
what happens, providing context information and desired output.

## License

[MIT License, Copyright (c) 2020 Boldare](LICENSE)


