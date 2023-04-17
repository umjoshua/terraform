resource "aws_key_pair" "levelup-key" {
  key_name   = "levelup-key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "sample-ec2" {

  instance_type = "t2.micro"
  ami           = "ami-0f2e14a2494a72db9"

  vpc_security_group_ids = [aws_security_group.levelup-sg.id]
  subnet_id = aws_subnet.levelup-vpc-public-subnet-1.id

  key_name = aws_key_pair.levelup-key.key_name
  availability_zone = "ap-south-1a"
}
