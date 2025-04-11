terraform {
  backend "s3" {
    bucket = "terraform-state-vpc-2444433"
    key    = "network/terraform.tfstate"
    region = "ap-south-1"
  }
}
