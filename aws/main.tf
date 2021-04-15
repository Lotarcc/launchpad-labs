provider "aws" {
  region                  = var.aws_region
  shared_credentials_file = var.aws_shared_credentials_file
  profile                 = var.aws_profile
}

module "vpc" {
  source       = "./modules/vpc"
  cluster_name = var.cluster_name
  host_cidr    = var.vpc_cidr
}

module "common" {
  source       = "./modules/common"
  cluster_name = var.cluster_name
  vpc_id       = module.vpc.id
  os_family    = var.os_family
  os_version   = var.os_version
}

module "masters" {
  source                = "./modules/master"
  master_count          = var.master_count
  vpc_id                = module.vpc.id
  cluster_name          = var.cluster_name
  subnet_ids            = module.vpc.public_subnet_ids
  security_group_id     = module.common.security_group_id
  image_id              = module.common.image_id
  kube_cluster_tag      = module.common.kube_cluster_tag
  ssh_key               = var.cluster_name
  instance_profile_name = module.common.instance_profile_name
}

module "msrs" {
  # count                 = var.msr_count
  source                = "./modules/msr"
  msr_count             = var.msr_count
  vpc_id                = module.vpc.id
  cluster_name          = var.cluster_name
  subnet_ids            = module.vpc.public_subnet_ids
  security_group_id     = module.common.security_group_id
  image_id              = module.common.image_id
  kube_cluster_tag      = module.common.kube_cluster_tag
  ssh_key               = var.cluster_name
  instance_profile_name = module.common.instance_profile_name
}

module "workers" {
  source                = "./modules/worker"
  worker_count          = var.worker_count
  vpc_id                = module.vpc.id
  cluster_name          = var.cluster_name
  subnet_ids            = module.vpc.public_subnet_ids
  security_group_id     = module.common.security_group_id
  image_id              = module.common.image_id
  kube_cluster_tag      = module.common.kube_cluster_tag
  ssh_key               = var.cluster_name
  instance_profile_name = module.common.instance_profile_name
  worker_type           = var.worker_type
}

module "windows_workers" {
  source                         = "./modules/windows_worker"
  worker_count                   = var.windows_worker_count
  vpc_id                         = module.vpc.id
  cluster_name                   = var.cluster_name
  subnet_ids                     = module.vpc.public_subnet_ids
  security_group_id              = module.common.security_group_id
  image_id                       = module.common.windows_2019_image_id
  kube_cluster_tag               = module.common.kube_cluster_tag
  instance_profile_name          = module.common.instance_profile_name
  worker_type                    = var.worker_type
  windows_administrator_password = var.windows_administrator_password
}

locals {
  managers        = [for host in module.masters.machines : host.public_ip]
  msrs            = [for host in module.msrs.machines : host.public_ip]
  workers         = [for host in module.workers.machines : host.public_ip]
  windows_workers = [for host in module.windows_workers.machines : host.public_ip]
  private_interface = [for x in
    [
      { id = "rhel", interface = "eth0" },
      { id = "ubuntu", interface = "ens5" },
      { id = "centos", interface = "eth0" },
      { id = "oracle", interface = "ens5" },
      { id = "suse", interface = "eth0" }
  ] : x.interface if x.id == var.os_family]
  ssh_username = [for x in
    [
      { id = "rhel", username = "ec2-user" },
      { id = "ubuntu", username = "ubuntu" },
      { id = "centos", username = "centos" },
      { id = "oracle", username = "ec2-user" },
      { id = "suse", username = "ec2-user" }
  ] : x.username if x.id == var.os_family]
}


output "mke_cluster" {
  value = templatefile("templates/launchpad.tpl", {
    kind                           = var.msr_count >= 1 ? "mke+msr" : "mke"
    keyPath                        = "./ssh_keys/${var.cluster_name}.pem"
    managers                       = local.managers
    msrs                           = local.msrs
    workers                        = local.workers
    windows_workers                = local.windows_workers
    mke_version                    = var.mke_version
    admin_username                 = var.admin_username
    admin_password                 = var.admin_password
    windows_administrator_password = var.windows_administrator_password
    masters_lb_dns_name            = module.masters.lb_dns_name
    license_file_path              = var.license_file_path
    msr_version                    = var.msr_version
    msrs_lb_dns_name               = module.msrs.lb_dns_name
    mcr_version                    = var.mcr_version
    os_ssh_username                = local.ssh_username[0]
    privateInterface               = local.private_interface[0]
    }
  )
}
