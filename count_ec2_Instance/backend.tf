terraform {
  backend "s3" {
    bucket = "terraform-state-prod-5312663"
    key    = "network/terraform.tfstate"
    region = "ap-south-1"
  }
}
