variable "os_family" {
  default = "rhel"
}

variable "os_version" {
  default = "7.9"
}

variable "mke_version" {
  # default = "3.3.7"
  description = "MKE Version"
  validation {
    condition     = (can(regex("([3].)([1-4].)\\d{1,2}", var.mke_version)))
    error_message = "The version of MKE is not correct."
  }
}
variable "msr_version" {
  default = "2.8.5"
}
variable "mcr_version" {
  default = "19.03.14"
}

variable "cluster_name" {
  default = "mke"
}

variable "aws_region" {
  default = "eu-west-2"
}

variable "aws_shared_credentials_file" {
  default = "~/.aws/credentials"
}

variable "aws_profile" {
  default = "kaas"
}

variable "vpc_cidr" {
  default = "172.31.0.0/16"
}

variable "admin_username" {
  default = "admin"
}

variable "admin_password" {
  default = ""
}

variable "master_count" {
  default = 1
}

variable "worker_count" {
  default = 0
}

variable "windows_worker_count" {
  default = 0
}

variable "msr_count" {
  default = 0
}

variable "master_type" {
  default = "m5.large"
}

variable "worker_type" {
  default = "m5.large"
}

variable "msr_type" {
  default = "m5.large"
}
variable "master_volume_size" {
  default = 100
}

variable "worker_volume_size" {
  default = 100
}

variable "msr_volume_size" {
  default = 100
}
variable "windows_administrator_password" {
  default = "w!ndozePassw0rd"
}

variable "license_file_path" {
  default = ""
}
