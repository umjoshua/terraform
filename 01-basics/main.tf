resource "aws_instance" "firstInstance" {
    count = 2
    ami = "ami-0984771b0c4f6fdf4"
    instance_type = "t2.micro"
}