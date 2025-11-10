terraform {
    cloud {
      organization = "goormdotcom"
      hostname = "app.terraform.io"
      workspaces {
        name = "prod"
      }
    }

    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
      }
    }
}

provider "aws" {
  region = var.aws_region
}

module "common_network" {
  source = "./modules/common-network"
}

output "common_network" {
  value = module.common_network.vpc_id
}

output "common_network_public_subnet_id" {
  value = module.common_network.public_subnet_id
}

output "common_network_private_subnet_app_id" {
  value = module.common_network.private_subnet_app_id
}

output "common_network_private_subnet_db_id" {
  value = module.common_network.private_subnet_db_id
}