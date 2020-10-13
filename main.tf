provider "aws" {
  region = var.region
}
// Variables
//
variable "project_name" {
  default = "terraform-bastion"
}


variable "region" {
  default = "us-east-1"
}

variable "source_ami" {
  default = "ami-9a562df2"
}


variable "vpc_cidr" {
  default = "172.31.0.0/16"
}

variable "vpc_cidrs" {
  default = "172.31.0.0/20,172.31.16.0/20,172.31.32.0/20,172.31.48.0/20"
}

//
// Outputs
//
# output "bastion_host" {
#   value = aws_instance.bastion.public_ip
# }

# output "web_host" {
#   value = aws_instance.web.private_ip
# }
# output "app_host" {
#   value = aws_instance.app.private_ip
# }