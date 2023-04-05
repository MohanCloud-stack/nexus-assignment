provider "aws" {
  region ="ap-south-1"
  access_key = ""
  secret_key = ""
}

resource "aws_vpc" "main"{
     cidr_block = "10.0.0.0/16"
     tags={
      Name="Nexus VPC"
    }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "My Internet Gateway"
  }
}

resource "aws_route" "routeIGW" {
  route_table_id         = aws_vpc.main.main_route_table_id 
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_subnet" "pub-a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Public-a"
  }
}

resource "aws_subnet" "pub-b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Public-b"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_rt"
  }
} 
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.pub-a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.pub-b.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_security_group" "nexus-sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "nexus-sg"
  }
}

resource "aws_lb" "test_lb" {
  name               = "aws-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.nexus-sg.id]
  subnets            = [aws_subnet.pub-a.id,aws_subnet.pub-b.id]

#   enable_deletion_protection = true
  tags = {
    Environment = "Nexus security groups"
  }
}
resource "aws_lb_listener" "front-end" {
    load_balancer_arn = aws_lb.test_lb.arn
    port="80"
    protocol = "HTTP"
    default_action {
    type = "forward"
     target_group_arn = aws_lb_target_group.my_tg.arn
  }
  
}

resource "aws_lb_target_group" "my_tg" {
  name     = "my-tg"
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}
#create an EC2 instance
resource "aws_instance" "demoinstance1" {
  ami           = "ami-03a933af70fa97ad2"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.nexus-sg.id]
   subnet_id = aws_subnet.pub-a.id
   associate_public_ip_address = true
  tags = {
    Name = "My IAAC Instance"
  }
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.my_tg.arn
  target_id        = aws_instance.demoinstance1.id
  port             = 80
}

resource "aws_db_instance" "default" {
  allocated_storage           = 10
  db_name                     = "mydb"
  engine                      = "mysql"
  engine_version              = "5.7"
  instance_class              = "db.t3.micro"
  manage_master_user_password = true
  username                    = "foo"
  parameter_group_name        = "default.mysql5.7"
}