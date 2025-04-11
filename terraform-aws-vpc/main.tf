resource "aws_s3_bucket" "state_bucket" {
  bucket = "terraform-state-vpc-2444433"

  tags = {
    Name        = "State bucket"
    Environment = "Dev"
  }
}

resource "aws_vpc" "main_vpc" {
  # Create vpc 
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MainVPC"
  }
}

resource "aws_subnet" "public_subnet" {
  # Public subnet configuartion
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "publicSubnet"
  }
}
resource "aws_subnet" "private_subnet" { # Private subnet configuartion

  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "privateSubnet"
  }

}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id # Internet Gateway for Public subnet

  tags = {
    Name = "Igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id # Route table for public subnet

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {

    Name = "PublicRT"
  }
}

resource "aws_route_table_association" "RT_att" {
  subnet_id      = aws_subnet.public_subnet.id # associate with public subnet
  route_table_id = aws_route_table.public_rt.id
}

# Security Group for public Instance
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.main_vpc.id

}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Security Group for private Instance
resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.main_vpc.id

}

resource "aws_vpc_security_group_ingress_rule" "allow_tls" {
  security_group_id = aws_security_group.private_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}




# Public EC2 (Bastion Host)

resource "aws_instance" "public_instance" {
  ami                    = "ami-0c50b6f7dc3701ddd"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "bastionSever"

  }
}

# Private EC2 ( backend server)
resource "aws_instance" "private_instance" {
  ami                    = "ami-0c50b6f7dc3701ddd"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]


  tags = {
    Name = "backend_server"
  }
}

# create NAT Gateway fo outboud internet access from private instance

resource "aws_eip" "nat_eip" {
  instance = aws_instance.public_instance.id
}

resource "aws_nat_gateway" "nat_gatwway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_subnet.id
  depends_on = [aws_internet_gateway.gw]
}

# Create Route table an Route for Private
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id
  
}

resource "aws_route" "private_rt_route" {
  route_table_id = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gatwway.id
}

resource "aws_route_table_association" "private_rt_assoc" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.private_subnet.id
}