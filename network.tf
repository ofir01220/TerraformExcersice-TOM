# ------------------------------
#Main vpc 
# ------------------------------
resource "aws_vpc" "main_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Main vpc"
  }
}


# ------------------------------
#public subnet
# ------------------------------
resource "aws_subnet" "public_subnet" {
  vpc_id        = aws_vpc.main_vpc.id
  cidr_block    = "10.0.1.0/24"

  map_public_ip_on_launch = true

  tags   = {
    Name = "Public Subnet"
  }
  depends_on = [ aws_vpc.main_vpc ]
}

# ------------------------------
#private subnet
# ------------------------------
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Private Subnet"
  }
  depends_on = [ aws_vpc.main_vpc ]
}

# ------------------------------
#internet gateway for the public subnet.
# ------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "Main IGW"
  }
  depends_on = [ aws_vpc.main_vpc ]
}

# ------------------------------
# Elastic IP for NAT Gateway
# ------------------------------
resource "aws_eip" "nat_eip" {
  domain     = "vpc" 
  depends_on = [aws_internet_gateway.igw] 
  tags = {
    Name = "NAT Gateway EIP"
  }
}


# ------------------------------
# nat gateway for private subnet. 
# ------------------------------
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id 

  tags = {
    Name = "Main NAT Gateway"
  }

  depends_on = [aws_subnet.public_subnet, aws_eip.nat_eip]
}
# ------------------------------
# Public Route Table
# ------------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
  depends_on = [ aws_vpc.main_vpc, aws_internet_gateway.igw ]
}

# ------------------------------
# Private Route Table 
# ------------------------------
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id # <--- Route traffic via NAT Gateway ID
  }

  tags = {
    Name = "Private Route Table" # <--- Corrected Tag Name
  }
  # Ensure VPC and NAT Gateway are created before route table
  depends_on = [aws_vpc.main_vpc, aws_nat_gateway.nat_gateway]
}


# ------------------------------
# route table assosiation with the public subnet.
# ------------------------------
resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id

  depends_on = [ aws_route_table.public_rt , aws_subnet.public_subnet ]
}


# ------------------------------
# route table assosiation with the private subnet.
# ------------------------------
resource "aws_route_table_association" "route_table_association2" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id

  depends_on = [ aws_route_table.private_rt , aws_subnet.private_subnet ]
}






