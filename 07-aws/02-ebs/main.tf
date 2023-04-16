resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup-key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_security_group" "ssh_access" {
  name_prefix = "ssh-access"
  ingress {
    from_port   = 0
    to_port     = 65535
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

resource "aws_instance" "sample-instance" {
  ami               = lookup(var.AMIS, var.AWS_REGION)
  availability_zone = "ap-south-1a"
  instance_type     = "t2.micro"
  key_name = aws_key_pair.levelup_key.key_name

  vpc_security_group_ids = [aws_security_group.ssh_access.id]


  tags = {
    Name = "sample-instance"
  }
}

resource "aws_ebs_volume" "ebs-volume-1" {
  availability_zone = "ap-south-1a"
  size = 50
  type = "gp2"
}

resource "aws_volume_attachment" "ebs-1-attachment" {
  device_name = "/dev/sdd"
  volume_id = aws_ebs_volume.ebs-volume-1.id
  instance_id = aws_instance.sample-instance.id
}