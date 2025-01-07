#create VPC
resource "aws_vpc" "project_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "Project_VPC"
  }
}

# create public subnet 1
resource "aws_subnet" "pub_sub1" {
  vpc_id     = aws_vpc.project_vpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone = var.subnet1_az

  tags = {
    Name = "public_subnet1"
  }
}
# create public subnet 2
resource "aws_subnet" "pub_sub2" {
  vpc_id     = aws_vpc.project_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = var.subnet2_az
  tags = {
    Name = "public_subnet2"
  }
}

# create AWS internet Gateway
resource "aws_internet_gateway" "project_igw" {
  vpc_id = aws_vpc.project_vpc.id

  tags = {
    Name = "Project_IGW"
  }
}

# create Route Table

resource "aws_route_table" "project_rt" {
  vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project_igw.id
  }

  tags = {
    Name = "Project_RT"
  }
}

# associte rout tabel to public subnet 1
resource "aws_route_table_association" "project_rt_sub_assc1" {
  subnet_id      = aws_subnet.pub_sub1.id
  route_table_id = aws_route_table.project_rt.id
}

# associate rout tabel to public subnet 2
resource "aws_route_table_association" "project_rt_sub_assc2" {
  subnet_id      = aws_subnet.pub_sub2.id
  route_table_id = aws_route_table.project_rt.id
}

# create security group for EC2 and Load Balancer
resource "aws_security_group" "project_sg" {
  name        = "project_sg"
  vpc_id      = aws_vpc.project_vpc.id

  tags = {
    Name = "Project_SG"
  }
}

# Adding inbound rule for HTTP in security group
resource "aws_vpc_security_group_ingress_rule" "sg_rules_inbound_http" {
  security_group_id = aws_security_group.project_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
# Adding inbound rule for SSH in security group
resource "aws_vpc_security_group_ingress_rule" "sg_rules_inbound_ssh" {
  security_group_id = aws_security_group.project_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Adding outbound rules for security group
resource "aws_vpc_security_group_egress_rule" "sg_rules_outbound" {
  security_group_id = aws_security_group.project_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Creaating web server 1
resource "aws_instance" "web_server_1" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.pub_sub1.id
  user_data = base64encode(file("userdata1.sh"))
  security_groups = [aws_security_group.project_sg.id]
  tags = {
    Name = "Webserver_1"
  }
}

# Creaating web server 2
resource "aws_instance" "web_server_2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.pub_sub2.id
  user_data = base64encode(file("userdata2.sh"))
  security_groups = [aws_security_group.project_sg.id]
  tags = {
    Name = "Webserver_2"
  }
}

# create application load balancer
resource "aws_lb" "project_alb" {
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.project_sg.id]
  subnets            = [aws_subnet.pub_sub1.id,aws_subnet.pub_sub2.id]

  enable_deletion_protection = true


  tags = {
   Name = "project_alb"
  }
}

resource "aws_lb_target_group" "project_tg" {
  
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.project_vpc.id

   health_check {
    path = "/"
    port = "traffic-port"
  }
  tags = {
    Name = "project_tg"
  }
}

# registering web server 1 with target group
resource "aws_lb_target_group_attachment" "register_webserver1" {
  target_group_arn = aws_lb_target_group.project_tg.arn
  target_id        = aws_instance.web_server_1.id
  port             = 80
}
# registering web server 2 with target group
resource "aws_lb_target_group_attachment" "register_webserver2" {
  target_group_arn = aws_lb_target_group.project_tg.arn
  target_id        = aws_instance.web_server_2.id
  port             = 80
}

# add listner rules for load balancer
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.project_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.project_tg.arn
    type             = "forward"
  }
}

# Display the DNS name of the load balancer
output "loadbalancerdns" {
  value = aws_lb.project_alb.dns_name
}

























