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
