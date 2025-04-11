#------------------------
#public security group 
#------------------------
resource "aws_security_group" "public_sg" {
    name    = "public-sg"
    vpc_id  = aws_vpc.main_vpc.id

    ingress  {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks  = ["0.0.0.0/0"]

    }
    ingress {
    description = "OpenVPN AS Admin/Client Web UI"
    from_port   = 943
    to_port     = 943
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    description = "OpenVPN AS VPN Traffic (TCP Default)"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
     description = "OpenVPN AS VPN Traffic (UDP Optional)"
     from_port   = 1194
     to_port     = 1194
     protocol    = "udp"
     cidr_blocks = ["0.0.0.0/0"] 
   }

    egress  {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks  = ["0.0.0.0/0"]
    }

    tags = {
      name : "Public Security Group"
    }
  
}

#------------------------
#private security group 
#------------------------
resource "aws_security_group" "private_sg" {
    name    = "private-sg"
    vpc_id  = aws_vpc.main_vpc.id

    ingress  {
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        security_groups  = [aws_security_group.public_sg.id]
        
    }
    ingress {
        from_port   = 0            
        to_port     = 0             
        protocol    = "-1"  
        cidr_blocks = [var.vpn_client_cidr]
        description = "Allow traffic from VPN clients"
    }
    egress  {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks  = ["0.0.0.0/0"]
    }

    tags = {
      name : "private Security Group"
    }
  
}