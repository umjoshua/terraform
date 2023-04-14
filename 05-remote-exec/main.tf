resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_security_group" "ssh_access" {
  name_prefix = "example"
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
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t3.micro"
  key_name      = aws_key_pair.levelup_key.key_name

  vpc_security_group_ids = [aws_security_group.ssh_access.id]

  tags = {
    Name = "sample-instance"
  }

  provisioner "file" {
    source      = "install-nginx.sh"
    destination = "/tmp/install-nginx.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-nginx.sh",
      "sh /tmp/install-nginx.sh",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.PATH_TO_PRIVATE_KEY)
    host        = self.public_ip
  }
}
