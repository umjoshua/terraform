resource "aws_instance" "sample-instance" {
    instance_type = "t3.micro"
    ami = "ami-0f2e14a2494a72db9"
    key_name = "test"
    vpc_security_group_ids = ["sg-068129d7166bd85d1"]
}

output "public-ip" {
  value = aws_instance.sample-instance.public_ip
}