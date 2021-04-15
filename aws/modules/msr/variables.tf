variable "cluster_name" {}

variable "vpc_id" {}

variable "instance_profile_name" {}

variable "security_group_id" {}

variable "subnet_ids" {
  type = list(string)
}

variable "image_id" {}

variable "kube_cluster_tag" {}

variable "ssh_key" {
  description = "SSH key name"
}

variable "msr_count" {
  default = 3
}

variable "msr_type" {
  default = "m5.large"
}

variable "msr_volume_size" {
  default = 100
}
