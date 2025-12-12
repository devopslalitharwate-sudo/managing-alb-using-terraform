#vpc
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    "Name" = "my_vpc"
  }
}


#subnets
resource "aws_subnet" "subnets" {
  count = length(var.subnets)
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "my-vpc-subnet-${count.index + 1}"
  }
}

#internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-vpc-internet-gateway"
  }
}

#route
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

 

  tags = {
    Name = "my-vpc-route-table"
  }
}

#route table associate

resource "aws_route_table_association" "a" {
  count = length(var.subnets)
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.rt.id
}