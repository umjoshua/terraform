data "aws_availability_zones" "available" {}

data "aws_ami" "ubuntu-ami" {
    most_recent = true
    owners = ["704109570831"]

    filter {
        name = "name"
        values = ["ztna_ubuntu2004"]
    }
}

resource "aws_instance" "firstInstance" {
    availability_zone = data.aws_availability_zones.available.names[1]
    ami = data.aws_ami.ubuntu-ami.id
    instance_type = "t2.micro"
}