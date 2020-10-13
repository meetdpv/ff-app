# resource "null_resource" "connect_bastion" {
#   connection {
#     host        = aws_instance.bastion.public_ip
#     type        = "ssh"
#     user        = "ubuntu"
#     private_key = file("./key")
#   }

#   provisioner "remote-exec" {
#     inline = ["echo 'CONNECTED to BASTION!'"]
#   }
# }

# resource "null_resource" "connect_private" {
#   connection {
#     bastion_host = aws_instance.bastion.public_ip
#     host         = aws_instance.web.public_ip
#     type         = "ssh"
#     user         = "ubuntu"
#     private_key  = file("./key")
#   }

#   provisioner "remote-exec" {
#     inline = ["echo 'CONNECTED to Web!'"]
#   }
# }