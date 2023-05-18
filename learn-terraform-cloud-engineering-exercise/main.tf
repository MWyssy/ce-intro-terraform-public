terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-2"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "terraform_vpc"
  cidr = "172.31.0.0/16"

  azs             = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  private_subnets = ["172.31.1.0/24", "172.31.3.0/24", "172.31.5.0/24"]
  public_subnets  = ["172.31.0.0/24", "172.31.2.0/24", "172.31.4.0/24"]

  enable_nat_gateway = true

}

# //VPC creation
# resource "aws_vpc" "terraform_vpc" {
#   cidr_block = var.base_cidr_block
#   tags = {
#     Name = "terraform_vpc"
#   }
# }

# //Public Subnets
# resource "aws_subnet" "terraform_public" {
#   count                   = 3
#   cidr_block              = "172.31.${count.index * 2}.0/24"
#   availability_zone       = var.availability_zones[count.index]
#   vpc_id                  = aws_vpc.terraform_vpc.id
#   map_public_ip_on_launch = "true"
#   tags = {
#     Name = "terraform_public_${count.index + 1}"
#   }
# }

# //Private Subnets
# resource "aws_subnet" "terraform_private" {
#   count             = 3
#   cidr_block        = "172.31.${(count.index * 2) + 1}.0/24"
#   availability_zone = var.availability_zones[count.index]
#   vpc_id            = aws_vpc.terraform_vpc.id

#   tags = {
#     Name = "terraform_private_${count.index + 1}"
#   }
# }

# //Internet Gateway
# resource "aws_internet_gateway" "terraform_gateway" {
#   vpc_id = aws_vpc.terraform_vpc.id
#   tags = {
#     Name = "terraform_gateway"
#   }
# }

# //Route Table and asscociations
# resource "aws_route_table" "terraform_routetable" {
#   vpc_id = aws_vpc.terraform_vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.terraform_gateway.id
#   }
#   tags = {
#     Name = "terraform_main_routetable"
#   }

# }
# resource "aws_route_table_association" "Public" {
#   count          = 3
#   subnet_id      = aws_subnet.terraform_public[count.index].id
#   route_table_id = aws_route_table.terraform_routetable.id
# }

# //Nat Gateway and private associations
# resource "aws_eip" "nat_eips" {
#   count = 3
#   vpc   = true
# }
# resource "aws_nat_gateway" "terraform_nats" {
#   count         = 3
#   allocation_id = aws_eip.nat_eips[count.index].id
#   subnet_id     = aws_subnet.terraform_public[count.index].id
#   tags = {
#     Name = "terraform_nat_${count.index + 1}"
#   }
# }
# resource "aws_route_table" "terraform_private_routetables" {
#   count  = 3
#   vpc_id = aws_vpc.terraform_vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.terraform_nats[count.index].id
#   }
#   tags = {
#     Name = "terraform_private${count.index + 1}_routetable"
#   }
# }
# resource "aws_route_table_association" "private" {
#   count          = 3
#   subnet_id      = aws_subnet.terraform_private[count.index].id
#   route_table_id = aws_route_table.terraform_private_routetables[count.index].id
# }

