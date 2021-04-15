# Bootstrapping MKE cluster on AWS

This directory provides an example flow for using Mirantis Launchpad with Terraform and AWS.

## Prerequisites

* An account and credentials for AWS.
* Terraform [installed](https://learn.hashicorp.com/terraform/getting-started/install)

## Steps

1. Create terraform.tfvars file with needed details. You can use the provided terraform.tfvars.example as a baseline.
2. `terraform init`
3. `terraform apply`
4. `terraform output mke_cluster | sed '1d;$d' | launchpad apply --config -`
