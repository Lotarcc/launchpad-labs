# Table of Contents

- [Prerequisits](#prerequisits)
- Install AWS CLI
  - [Install AWS Linux](#install-aws-linux)
  - [Install AWS Windows](#install-aws-windows)
  - [Install AWS MacOS](#instal-aws-macos)
- [Install Launchpad](#install-launchpad)
- [Configure AWS Credentials](#configure-aws-credentials)
  - [AWS SSO](#aws-sso)
  - [AWS non-SSO](#aws-non-sso)
- [Install Terraform](#install-terraform)

## Prerequisits

- Install Git
- Install Terraform
- Install AWS CLI v2
- Install Launchpad
- Clone this repo

## Install AWS Linux

Download: `curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"`

Verify Installation:

- Install unzip or equivalent
- unzip awscliv2.zip
- sudo ./aws/install
- In Terminal do “aws  --version”\

## Install AWS Windows

Download: <https://awscli.amazonaws.com/AWSCLIV2.msi>
Execute the file and install it.

Verify Installation:

- Open your CMD
- Execute the following command: aws --version

### Instal AWS MacOS

Download: <https://awscli.amazonaws.com/AWSCLIV2.pkg>

- Open the downloaded file to launch the installer.
- Follow on-screen instructions.
- Verify installation: “aws --version” in your Terminal

## Install Launchpad

1. Download launchpad
<https://github.com/Mirantis/launchpad/releases/tag/1.2.0>
2. Move launchpad to /usr/bin/launchpad
3. Check if it's installed correctly with:

```shell
launchpad register -n launchpadlabs -e nobody@nowhere.com -c Mirantis -a
```

## Configure AWS Credentials

### AWS SSO

Configure your AWS SSO login with following (Host Machine):

```shell
aws configure sso --profile KaaS
```

Output of the command:

```shell
SSO start URL [None]:https://mirantis.awsapps.com/start
SSO Region [None]: eu-west-2
The only AWS account available to you is: 043802220583
Using the account ID 043802220583
There are 3 roles available to you.
Using the role name "KaaS"
CLI default client Region [None]:eu-central-1
CLI default output format [None]:json

To use this profile, specify the profile name using --profile, as shown:

aws s3 ls --profile KaaS
```

Copy content of file `~/.aws/config` to `~/.aws/credentials` and delete `profile` from profile name in `credentials` file.
Put under `[default]` profile in `~/.aws/credentials` your access and secret key.

Sample:

```shell
Output of Config file:

[profile KaaS]
sso_start_url = https://mirantis.awsapps.com/start
sso_region = eu-west-2
sso_account_id = 043802220583
sso_role_name = KaaS_Demo
region = eu-central-1
output = json

How it will look in credentials file:

[KaaS]
sso_start_url = https://mirantis.awsapps.com/start
sso_region = eu-west-2
sso_account_id = 043802220583
sso_role_name = KaaS_Demo
region = eu-central-1
output = json

[default]
aws_access_key_id=[REDACTED]
aws_secret_access_key=[REDACTED]


```

Sample of the AWS SSO Login.

```shell
aws sso login --profile KaaS
```

Command Output:

```shell
SSO start URL [None]: https://mirantis.awsapps.com/start#/
SSO Region [None]:  eu-west-2
Attempting to automatically open the SSO authorization page in your default browser.
If the browser does not open or you wish to use a different device to authorize this request, open the following URL:
https://device.sso.eu-west-2.amazonaws.com/

Then enter the code:
<REDACTED>
Successully logged into Start URL:
https://mirantis.awsapps.com/start
```

### AWS non-SSO

Collect the following AWS access information from your AWS KaaS access portal and just paste it to your terminal.

```shell
export AWS_ACCESS_KEY_ID="ASIAQUMWQ3ATTWQD4ZFV"
export AWS_SECRET_ACCESS_KEY="kH+ClCBTRofpzollgeFiEMYw2qkyCatENBgEYdYL"
export AWS_SESSION_TOKEN="IQoJb3JpZ2luX2VjEDAaCWV1LXdlc3QtMiJGM"
```

## Install Terraform

1. Download Terraform for your OS from:
<https://releases.hashicorp.com/terraform/0.14.10/>
2. Put file from ZIP to `/usr/bin/` folder.
3. Check installation with `terraform version`.

## How to run your lab

1. Go into the cloned folder.
2. Set up your AWS SSO or Export tokens from AWS
3. Edit `terraform.tfvars` (You can copy example for yourself).
4. Execute `run.sh` file.
