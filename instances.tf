resource "aws_instance" "bastion" {
  instance_type = "t2.micro"
  ami           = var.source_ami
  key_name      = aws_key_pair.main.key_name

  #vpc_security_group_ids = [aws_security_group.default_egress.id, aws_security_group.admin_access_public.id, aws_security_group.admin_access_private.id]
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  subnet_id              = aws_subnet.bastion.id


  tags = {
    Name = "bastion"
  }
}

resource "aws_instance" "web" {
  instance_type = "t2.micro"
  ami           = var.source_ami
  key_name      = aws_key_pair.main.key_name

  #vpc_security_group_ids      = [aws_security_group.default_egress.id, aws_security_group.admin_access_private.id,aws_security_group.web_access_private.id]
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  subnet_id                   = aws_subnet.web.id
  associate_public_ip_address = true

  tags = {
    Name = "web"
  }
# user_data     = <<-EOF
#                   #!/bin/bash
#                   sudo su
#                   apt-get -y install httpd
#                   echo "<p> My Instance! </p>" >> /var/www/html/index.html
#                   sudo systemctl enable httpd
#                   sudo systemctl start httpd
#                   EOF  
// copy our example script to the server
provisioner "file" {
    source      = "./httpd.sh"
    destination = "./httpd.sh"
  }

  // change permissions to executable and pipe its output into a new file
provisioner "remote-exec" {
    inline = [
      "sudo chmod +x ./httpd.sh",
      "sudo ./httpd.sh"
    ]
  }                  
# provisioner "remote-exec" { 
# inline = [
#   "sudo mkdir -p /var/www/html/",
#   "sudo apt-get install -y httpd",
#   "sudo service httpd start",
#   "sudo usermod -a -G apache ubuntu",
#   "sudo chown -R ubuntu:apache /var/www",
#   "sudo yum install -y curl"
# ]
# }  
}

  resource "aws_instance" "app" {
  instance_type = "t2.micro"
  ami           = var.source_ami
  key_name      = aws_key_pair.main.key_name

  #vpc_security_group_ids      = [aws_security_group.default_egress.id, aws_security_group.app_access_private.id]
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  subnet_id                   = aws_subnet.app.id
  associate_public_ip_address = false

  tags = {
    Name = "app"
  }
# user_data     = <<-EOF
#                   #!/bin/bash
#                   sudo su
#                   apt-get -y install httpd
#                   echo "<p> My Instance! </p>" >> /var/www/html/index.html
#                   sudo systemctl enable httpd
#                   sudo systemctl start httpd
#                   EOF    
# provisioner "remote-exec" { 
# inline = [
#   "sudo mkdir -p /var/www/html/",
#   "sudo apt-get install -y httpd",
#   "sudo service httpd start",
#   "sudo usermod -a -G apache ubuntu",
#   "sudo chown -R ubuntu:apache /var/www",
#   "sudo yum install -y curl"
# ]
# }
# provisioner "file" {
#     source      = "./httpd.sh"
#     destination = "./httpd.sh"
#   }

#   // change permissions to executable and pipe its output into a new file
# provisioner "remote-exec" {
#     inline = [
#       "chmod +x ./httpd.sh",
#       "./httpd.sh > ./httpd",
#     ]
#   }    
}
