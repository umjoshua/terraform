variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {
    default = "eu-north-1"
}

variable "AMIS" {
    type = map
    default = {
        eu-north-1 = "ami-064087b8d355e9051"
    }
}

variable "PATH_TO_PUBLIC_KEY" {
    default = "./levelup_key.pub"
}

variable "PATH_TO_PRIVATE_KEY" {
    default = "./levelup_key"
}