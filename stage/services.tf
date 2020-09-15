provider "aws" {
  region     = "eu-central-1"
  shared_credentials_file = var.shared_credentials_file
  profile                 = ""
}

terraform {
  backend "s3" {
    bucket = "terraform-state-24i"
    key    = "stage/services/sentry/terraform.tfstate"
    region = "eu-central-1"
    dynamodb_table = "terraform-locks-24i"
  }
}

module "vpc" {
  source       = "github.com/vinothav/terraform_modules//vpc?ref=v0.0.1"
  cluster_name = var.cluster_name
  cidr_block   = var.cidr_block
}

module "sg" {
  source   = "github.com/vinothav/terraform_modules//sg?ref=v0.0.1"
  main_vpc = module.vpc.vpc_id
  ec2_ingress = [
    {
      description = "SSH access"
      from_port   = 0
      to_port     = 22
      protocol    = 6
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "nginx access"
      from_port   = 0
      to_port     = 9000
      protocol    = 6
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  majorcomponents_ingress = [
    {
      description = "postgres access"
      from_port   = 0
      to_port     = 5432
      protocol    = 6
    },
    {
      description = "nginx access"
      from_port   = 0
      to_port     = 6379
      protocol    = 6
    },
    {
      description = "ec2 traffic inbound"
      from_port   = 0
      to_port     = 0
      protocol    = -1
    }
  ]
}

module "ec2_instance" {
  source = "github.com/vinothav/terraform_modules//ec2_instance?ref=v0.0.1"
  ec2_sg = [module.sg.ec2_sg_id]
  subnet = module.vpc.public_subnet_ids[0]
  instance_type = var.ec2_instance_type
}

module "db" {
  source = "github.com/vinothav/terraform_modules//db?ref=v0.0.1"
  db_instance_type = var.db_instance_type
  sg = [module.sg.majcom_sg_id]
  subnet_name = module.vpc.public_subnet_ids
}

module "redis" {
  source = "github.com/vinothav/terraform_modules//redis?ref=v0.0.1"
  node_type = var.node_type
  sg = [module.sg.majcom_sg_id]
  subnet_ids = module.vpc.public_subnet_ids
}

module "msk" {
  source = "github.com/vinothav/terraform_modules//msk?ref=v0.0.1"
  kafka_node_type = var.kafka_node_type
  sg = [module.sg.majcom_sg_id]
  subnets = module.vpc.public_subnet_ids
}





