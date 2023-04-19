variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {
    default = "ap-south-1"
}

variable "AMI" {
    default = "ami-0f2e14a2494a72db9"
}

variable "PATH_TO_PUBLIC_KEY" {
    default = "./levelup_key.pub"
}