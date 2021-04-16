#!/usr/bin/env sh

terraform init && terraform plan
terraform apply --auto-approve -compact-warnings
terraform output --raw mke_cluster > ./launchpad.yaml
launchpad apply
