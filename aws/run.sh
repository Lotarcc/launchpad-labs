#!/usr/bin/env sh

# run.sh may run from any dir with full path to it
# Doesn't matter where we are running
# It wants to know for which labname/caseid it can be ran
# You need to specify arguments for CaseID running dir

read -rp "Write CaseID or another Lab Name: " LABNAME
echo .....................................................
echo "$LABNAME"
echo .....................................................
while true; do
    read -rp "Do you want to use current dir to save state files? " yn
    case $yn in
        [Yy]* ) LAUNCHPAD_LABS_DIR=$(pwd); break;;
        [Nn]* ) read -rp "Please type path where to save state files: " LAUNCHPAD_LABS_DIR; break;;
        * ) echo "Please answer Yes or No.";;
    esac
done

echo "Using this directory: $LAUNCHPAD_LABS_DIR"

# Create catalog where we are working


docker image pull lotarc/launchpadlabs
docker run -it --rm --name "$LABNAME" \
-v ~/.aws:/home/root/.aws \
-v "$LAUNCHPAD_LABS_DIR":/launchpadlabs/terraform.tfvars \
-v "$LAUNCHPAD_LABS_DIR":/launchpadlabs/terraform.tfstate \
-v "$LAUNCHPAD_LABS_DIR":/launchpadlabs/launchpad.yaml \
launchpadlabs:latest