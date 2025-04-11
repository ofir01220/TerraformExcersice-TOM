variable "aws_region" {
    type = string
    description = "The AWS region to deploy resources in"
    default = "us-east-1"
}
variable "ec2_instance_type" {
    type = string
    default = "t2.micro"
}

variable "ec2_ami_us-east-1" {
  type = string
  default = "ami-084568db4383264d4"
}

variable "vpn_client_cidr" {
  description = "CIDR block assigned to VPN clients by OpenVPN server"
  type        = string
  default     = "10.8.0.0/24" # Must match the 'server' directive in server.conf
}