resource "aws_instance" "firstInstance" {
    count = 2
    ami = lookup(var.AMIS, var.AWS_REGION)
    instance_type = "t2.micro"
}