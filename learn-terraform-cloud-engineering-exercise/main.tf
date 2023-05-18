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


resource "aws_vpc" "terraform_vpc" {
  cidr_block = "172.31.0.0/16"
  tags = {
    Name = "terraform_vpc"
  }
}

resource "aws_subnet" "terraform_public_1" {
  cidr_block              = "172.31.0.0/24"
  availability_zone       = "eu-west-2a"
  vpc_id                  = aws_vpc.terraform_vpc.id
  map_public_ip_on_launch = "true"
  tags = {
    Name = "terraform_public_1"
  }
}

resource "aws_subnet" "terraform_private_1" {
  cidr_block        = "172.31.1.0/24"
  availability_zone = "eu-west-2a"
  vpc_id            = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform_private_1"
  }
}

resource "aws_subnet" "terraform_public_2" {
  cidr_block              = "172.31.2.0/24"
  availability_zone       = "eu-west-2b"
  vpc_id                  = aws_vpc.terraform_vpc.id
  map_public_ip_on_launch = "true"
  tags = {
    Name = "terraform_public_2"
  }
}

resource "aws_subnet" "terraform_private_2" {
  cidr_block        = "172.31.3.0/24"
  availability_zone = "eu-west-2b"
  vpc_id            = aws_vpc.terraform_vpc.id
  tags = {
    Name = "terraform_private_2"
  }
}

resource "aws_subnet" "terraform_public_3" {
  cidr_block              = "172.31.4.0/24"
  availability_zone       = "eu-west-2c"
  vpc_id                  = aws_vpc.terraform_vpc.id
  map_public_ip_on_launch = "true"
  tags = {
    Name = "terraform_public_3"
  }
}

resource "aws_subnet" "terraform_private_3" {
  cidr_block        = "172.31.5.0/24"
  availability_zone = "eu-west-2c"
  vpc_id            = aws_vpc.terraform_vpc.id
  tags = {
    Name = "terraform_private_3"
  }
}

resource "aws_internet_gateway" "terraform_gateway" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = {
    Name = "terraform_gateway"
  }
}

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

resource "aws_route_table_association" "One" {
  subnet_id      = aws_subnet.terraform_public_1.id
  route_table_id = aws_route_table.terraform_routetable.id
}

resource "aws_route_table_association" "Two" {
  subnet_id      = aws_subnet.terraform_public_2.id
  route_table_id = aws_route_table.terraform_routetable.id
}

resource "aws_route_table_association" "Three" {
  subnet_id      = aws_subnet.terraform_public_3.id
  route_table_id = aws_route_table.terraform_routetable.id
}


//Private Subnet 1
resource "aws_eip" "nat_eip1" {
  vpc = true
}

resource "aws_nat_gateway" "terraform_nat1" {
  allocation_id = aws_eip.nat_eip1.id
  subnet_id     = aws_subnet.terraform_public_1.id
  tags = {
    Name = "terraform_nat_1"
  }
}

resource "aws_route_table" "terraform_private1_routetable" {
  vpc_id = aws_vpc.terraform_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.terraform_nat1.id
  }
  tags = {
    Name = "terraform_private1_routetable"
  }
}
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.terraform_private_1.id
  route_table_id = aws_route_table.terraform_private1_routetable.id
}


//Private Subnet 2
resource "aws_eip" "nat_eip2" {
  vpc = true
}

resource "aws_nat_gateway" "terraform_nat2" {
  allocation_id = aws_eip.nat_eip2.id
  subnet_id     = aws_subnet.terraform_public_2.id
  tags = {
    Name = "terraform_nat_2"
  }
}

resource "aws_route_table" "terraform_private2_routetable" {
  vpc_id = aws_vpc.terraform_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.terraform_nat1.id
  }
  tags = {
    Name = "terraform_private2_routetable"
  }
}
resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.terraform_private_2.id
  route_table_id = aws_route_table.terraform_private2_routetable.id
}


//Private Subnet 3
resource "aws_eip" "nat_eip3" {
  vpc = true
}

resource "aws_nat_gateway" "terraform_nat3" {
  allocation_id = aws_eip.nat_eip3.id
  subnet_id     = aws_subnet.terraform_public_3.id
  tags = {
    Name = "terraform_nat_3"
  }
}

resource "aws_route_table" "terraform_private3_routetable" {
  vpc_id = aws_vpc.terraform_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.terraform_nat3.id
  }
  tags = {
    Name = "terraform_private3_routetable"
  }
}
resource "aws_route_table_association" "private3" {
  subnet_id      = aws_subnet.terraform_private_3.id
  route_table_id = aws_route_table.terraform_private3_routetable.id
}
