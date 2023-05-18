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

//VPC creation
resource "aws_vpc" "terraform_vpc" {
  cidr_block = var.base_cidr_block
  tags = {
    Name = "terraform_vpc"
  }
}


//Public Subnets
resource "aws_subnet" "terraform_public" {
  count                   = 3
  cidr_block              = "172.31.${count.index * 2}.0/24"
  availability_zone       = var.availability_zones[count.index]
  vpc_id                  = aws_vpc.terraform_vpc.id
  map_public_ip_on_launch = "true"
  tags = {
    Name = "terraform_public_${count.index + 1}"
  }
}

//Private Subnets
resource "aws_subnet" "terraform_private" {
  count             = 3
  cidr_block        = "172.31.${(count.index * 2) + 1}.0/24"
  availability_zone = var.availability_zones[count.index]
  vpc_id            = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform_private_${count.index + 1}"
  }
}


//Internet Gateway
resource "aws_internet_gateway" "terraform_gateway" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = {
    Name = "terraform_gateway"
  }
}


//Route Table and asscociations
resource "aws_route_table" "terraform_routetable" {
  vpc_id = aws_vpc.terraform_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_gateway.id
  }
  tags = {
    Name = "terraform_main_routetable"
  }

}

resource "aws_route_table_association" "Public" {
  count          = 3
  subnet_id      = aws_subnet.terraform_public[count.index].id
  route_table_id = aws_route_table.terraform_routetable.id
}

//Nat Gateway and private associations
resource "aws_eip" "nat_eips" {
  count = 3
  vpc   = true
}

resource "aws_nat_gateway" "terraform_nats" {
  count         = 3
  allocation_id = aws_eip.nat_eips[count.index].id
  subnet_id     = aws_subnet.terraform_public[count.index].id
  tags = {
    Name = "terraform_nat_${count.index + 1}"
  }
}

resource "aws_route_table" "terraform_private_routetables" {
  count  = 3
  vpc_id = aws_vpc.terraform_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.terraform_nats[count.index].id
  }
  tags = {
    Name = "terraform_private${count.index + 1}_routetable"
  }
}
resource "aws_route_table_association" "private" {
  count          = 3
  subnet_id      = aws_subnet.terraform_private[count.index].id
  route_table_id = aws_route_table.terraform_private_routetables[count.index].id
}


# //Private Subnet 2
# resource "aws_eip" "nat_eip2" {
#   vpc = true
# }

# resource "aws_nat_gateway" "terraform_nat2" {
#   allocation_id = aws_eip.nat_eip2.id
#   subnet_id     = aws_subnet.terraform_public_2.id
#   tags = {
#     Name = "terraform_nat_2"
#   }
# }

# resource "aws_route_table" "terraform_private2_routetable" {
#   vpc_id = aws_vpc.terraform_vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.terraform_nat1.id
#   }
#   tags = {
#     Name = "terraform_private2_routetable"
#   }
# }
# resource "aws_route_table_association" "private2" {
#   subnet_id      = aws_subnet.terraform_private_2.id
#   route_table_id = aws_route_table.terraform_private2_routetable.id
# }


# //Private Subnet 3
# resource "aws_eip" "nat_eip3" {
#   vpc = true
# }

# resource "aws_nat_gateway" "terraform_nat3" {
#   allocation_id = aws_eip.nat_eip3.id
#   subnet_id     = aws_subnet.terraform_public_3.id
#   tags = {
#     Name = "terraform_nat_3"
#   }
# }

# resource "aws_route_table" "terraform_private3_routetable" {
#   vpc_id = aws_vpc.terraform_vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.terraform_nat3.id
#   }
#   tags = {
#     Name = "terraform_private3_routetable"
#   }
# }
# resource "aws_route_table_association" "private3" {
#   subnet_id      = aws_subnet.terraform_private_3.id
#   route_table_id = aws_route_table.terraform_private3_routetable.id
# }
