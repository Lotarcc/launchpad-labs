#!/usr/bin/env sh

terraform apply -auto-approve -compact-warnings
terraform output --raw mke_cluster > ./launchpad.yaml
launchpad apply
