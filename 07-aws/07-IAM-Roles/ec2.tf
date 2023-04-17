#SSH
resource "aws_security_group" "levelup-sg" {
  name   = "levelup-ssh"

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


resource "aws_instance" "sample-ec2" {

  instance_type = "t2.micro"
  ami           = "ami-0f2e14a2494a72db9"

  vpc_security_group_ids = [aws_security_group.levelup-sg.id]
  
  iam_instance_profile = aws_iam_instance_profile.s3-test-bucket-instance-profile.name

}
