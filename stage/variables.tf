variable "shared_credentials_file" {}

variable "cluster_name" {
  description = "Input the cluster name"
  type        = string
}

variable "cidr_block" {
  description = "Input the cidr_block range for the vpc"
  type        = string
}

variable "ec2_instance_type" {
  description = "the instance type to be used for ec2"
  type = string
}

variable "db_instance_type" {
  description = "the instance type to be used for db"
  type = string
}

variable "node_type" {
  description = "The instance type for redis cluster"
  type = string
}

variable "kafka_node_type" {
  description = "The kafka node type to be used"
  type = string
}


