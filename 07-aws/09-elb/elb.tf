resource "aws_elb" "levelup-elb" {
  name            = "levelup-elb"
  subnets         = [aws_subnet.levelup-vpc-public-subnet-1.id, aws_subnet.levelup-vpc-public-subnet-2.id]
  security_groups = [aws_security_group.levelup-elb-sg.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400
}

resource "aws_security_group" "levelup-elb-sg" {
  vpc_id = aws_vpc.levelup-vpc.id
  name   = "levelup-elb-sg"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "levelup-instance-sg" {
  vpc_id = aws_vpc.levelup-vpc.id
  name   = "levelup-instance-sg"
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.levelup-elb-sg.id]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "ELB" {
  value = aws_elb.levelup-elb.dns_name
}
