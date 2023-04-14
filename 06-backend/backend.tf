terraform {
  backend "s3" {
    key = "06-backend/tfstate"
    bucket = "tf-state-01spd"
    region = "ap-south-1"
  }
}