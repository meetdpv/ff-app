# resource "aws_key_pair" "main" {
#   key_name   = "${var.project_name}"
#   public_key = "${file("~/.ssh/id_rsa.pub")}"
# }

resource "aws_key_pair" "main" {
  key_name   = "ubuntu"
  public_key = file("key.pub")
}

# variable "key_name" {}

# resource "tls_private_key" "example" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "main" {
#   key_name   = "var.key_name"
#   public_key = "tls_private_key.example.public_key_openssh"
# }