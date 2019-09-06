resource "aws_vpc" "demo_vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_subnet" {
  cidr_block = var.public_subnet_cidr_block
  vpc_id = aws_vpc.demo_vpc.id
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_name
  }
}

resource "aws_subnet" "private_subnet" {
  cidr_block = var.private_subnet_cidr_block
  vpc_id = aws_vpc.demo_vpc.id
  map_public_ip_on_launch = false
  tags = {
    Name = var.private_subnet_name
  }
}

resource "aws_internet_gateway" "demo_ig" {
  vpc_id = aws_vpc.demo_vpc.id
  tags = {
    Name = var.ig_name
  }
}

resource "aws_nat_gateway" "demo_nat_gateway" {
  allocation_id = aws_eip.demo_eip.id
  subnet_id = aws_subnet.public_subnet.id
}

resource "aws_eip" "demo_eip" {

}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.demo_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_ig.id
  }
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.demo_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.demo_nat_gateway.id
  }
  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "public-subnet_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.public_subnet.id
}

resource "aws_route_table_association" "private-subnet_association" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id = aws_subnet.private_subnet.id
}


output "vpc_id" {
  value = aws_vpc.demo_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}