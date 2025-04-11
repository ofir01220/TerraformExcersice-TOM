#--------------------
#provider
#--------------------

provider "aws" {
  region    = var.aws_region
}

# ------------------------------
# Public EC2 Instance
# ------------------------------
resource "aws_instance" "public_instance" {
  ami                    = var.ec2_ami_us-east-1
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  key_name               = aws_key_pair.deployer.key_name
  associate_public_ip_address = true
  source_dest_check      = false

  user_data = templatefile("${path.module}/openvpn.sh", {})
  
  tags = {
    Name = "PublicEC2"
  }

  depends_on = [ aws_security_group.public_sg ]
}

# ------------------------------
# Private EC2 Instance
# ------------------------------
resource "aws_instance" "private_instance" {
  ami                    = var.ec2_ami_us-east-1
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = aws_key_pair.deployer.key_name
  associate_public_ip_address = false

  tags = {
    Name = "PrivateEC2"
  }

  depends_on = [ aws_security_group.private_sg ]

}