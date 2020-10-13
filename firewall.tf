//
// Default Egress
//
# resource "aws_security_group" "default_egress" {
#   name        = "default_egress"
#   description = "Default Egress"
#   vpc_id      = aws_vpc.main.id

#   tags = {
#     Name = var.project_name
#   }
# }

# resource "aws_security_group_rule" "default_egress" {
#   security_group_id = aws_security_group.default_egress.id
#   type              = "egress"
#   protocol          = "-1"
#   from_port         = 0
#   to_port           = 0
#   cidr_blocks       = ["0.0.0.0/0"]
# }

//
// Administrative Access Public
//
resource "aws_security_group" "bastion-sg" {
  name        = "bastion-sg"
  description = "Admin Access Public"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "bastion-sg"
  }
}

resource "aws_security_group_rule" "admin_access_public_ssh" {
  security_group_id = aws_security_group.bastion-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

//
# // Administrative Access Private
# //
# resource "aws_security_group" "admin_access_private" {
#   name        = "admin_access_private"
#   description = "Admin Access Private"
#   vpc_id      = aws_vpc.main.id

#   tags = {
#     Name = var.project_name
#   }
# }

# resource "aws_security_group_rule" "admin_access_private_ssh" {
#   security_group_id = aws_security_group.admin_access_private.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 22
#   to_port           = 22
#   cidr_blocks       = [var.vpc_cidr]
# }

//
// Administrative Access Private
//

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Web Access Private"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "web-sg"
  }
}

resource "aws_security_group_rule" "web_sg" {
  security_group_id = aws_security_group.web_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "web_sg_gr_22" {
  security_group_id = aws_security_group.web_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
 # cidr_blocks       = [var.vpc_cidr]
  source_security_group_id = aws_security_group.bastion-sg.id
}

resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "App Access Private"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "app-sg"
}
}

resource "aws_security_group_rule" "app_sg_gr_22" {
  security_group_id = aws_security_group.app_sg.id
  # ingress {
  #   from_port = 22
  #   to_port = 22
  #   protocol = "tcp"
  #   cidr_blocks = [var.vpc_cidr]
  # }
  # ingress {
  #   from_port = 80
  #   to_port = 80
  #   protocol = "tcp"
    
  # }
  #cidr_blocks = [var.vpc_cidr]
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 80
#   to_port           = 80
#   cidr_blocks       = [var.vpc_cidr]

  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
 # cidr_blocks       = [var.vpc_cidr]
  source_security_group_id = aws_security_group.bastion-sg.id
}

resource "aws_security_group_rule" "app_access_gr_80" {
 # security_group_id = aws_security_group.app_access_private.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
 # cidr_blocks       = [var.vpc_cidr]
  security_group_id = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.web_sg.id
 
}

resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id
  subnet_ids = [aws_subnet.web.id]

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "deny"
    #cidr_block = "aws_instance.bastion.public_ip"/32"
    cidr_block = "${aws_instance.bastion.public_ip}/32"
    from_port  = 443
    to_port    = 443
  }

  tags = {
    Name = "web-nacl"
  }
}


