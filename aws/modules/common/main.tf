
data "aws_availability_zones" "available" {}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "ssh_public_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "ssh_keys/${var.cluster_name}.pem"
  provisioner "local-exec" {
    command = "chmod 0600 ${local_file.ssh_public_key.filename}"
  }
}

resource "aws_key_pair" "key" {
  key_name   = var.cluster_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

locals {

  # os_version_list = ["RHEL-${var.os_version}_HVM*x86_64*", "ubuntu/images/hvm-ssd/ubuntu-*-${var.os_version}*amd64*", "v3", "v4"]
  # os_family_list = ["rhel", "ubuntu", "suse", "centos"]
  # search_list = var.os_family

  linux = [for x in [
   { id = "rhel", filter = "RHEL-${var.os_version}_HVM*x86_64*" },
   { id = "ubuntu", filter = "ubuntu/images/hvm-ssd/ubuntu-*-${var.os_version}*amd64*" },
   { id = "centos", filter = "CentOS*${var.os_version}*x86_64"},
   { id = "oracle", filter = "OL${var.os_version}-x86_64-HVM-*" },
   { id = "suse", filter = "suse-sles-${var.os_version}-v????????-hvm-ssd-x86_64"}
   ] : x.filter if x.id == var.os_family]

  owner = [for x in [
   { id = "rhel", owner = "309956199498" },
   { id = "ubuntu", owner = "099720109477" },
   { id = "centos", owner = "125523088429"},
   { id = "oracle", owner = "131827586825" },
   { id = "suse", owner = "amazon"}
   ] : x.owner if x.id == var.os_family]
}
data "aws_ami" "linux" {
  most_recent = true

  filter {
    name = "name"
    values = [local.linux[0]]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # owners = ["309956199498"]
  owners = [local.owner[0]]
}

data "aws_ami" "windows_2019" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Core-ContainersLatest-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["801119661308"] # Amazon
}

resource "aws_security_group" "common" {
  name        = "${var.cluster_name}-common"
  description = "mke cluster common rules"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "role" {
  name = "${var.cluster_name}_host"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "profile" {
  name = "${var.cluster_name}_host"
  role = aws_iam_role.role.name
}

resource "aws_iam_role_policy" "policy" {
  name = "${var.cluster_name}_host"
  role = aws_iam_role.role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["ec2:*"],
      "Resource": ["*"]
    },
    {
      "Effect": "Allow",
      "Action": ["elasticloadbalancing:*"],
      "Resource": ["*"]
    },
    {
      "Effect": "Allow",
      "Action": ["ecr:*"],
      "Resource": ["*"]
    },
    {
      "Effect": "Allow",
      "Action": [
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
