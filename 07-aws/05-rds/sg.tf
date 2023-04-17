#SSH
resource "aws_security_group" "levelup-sg" {
  name   = "levelup-ssh"
  vpc_id = aws_vpc.levelup-vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#RDS MariaDB
resource "aws_security_group" "allow-mariadb" {
  name   = "allow-mariadb"
  vpc_id = aws_vpc.levelup-vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
    security_groups = [aws_security_group.levelup-sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
