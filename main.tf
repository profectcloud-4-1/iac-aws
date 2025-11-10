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