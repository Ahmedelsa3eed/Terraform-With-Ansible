resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "saeed-extra-tf-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "saeed-extra-tf-public-subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "saeed-extra-tf-igw"
  }
}

resource "aws_route_table" "public_route" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "saeed-extra-tf-public-route"
    }
}

resource "aws_route_table_association" "public_association" {
    subnet_id      = aws_subnet.public.id  
    route_table_id = aws_route_table.public_route.id
}

resource "aws_route" "igw-route" {
    route_table_id         = aws_route_table.public_route.id
    destination_cidr_block = var.from_any_where
    gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "allow_access_to_webserver"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = var.from_any_where
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = var.from_any_where
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = var.from_any_where
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = var.from_any_where
  ip_protocol       = "-1" # semantically equivalent to all ports
}