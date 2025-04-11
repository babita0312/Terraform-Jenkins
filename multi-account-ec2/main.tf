provider "aws" {
  alias   = "account1"
  profile = "default"
  region  = "ap-south-1"  # Change as per your setup
}

provider "aws" {
  alias   = "account2"
  profile = "second-account"
  region  = "ap-south-1"  # Change as per your setup
}

resource "aws_instance" "ec2_account1" {
  provider      = aws.account1
  ami           = "ami-002f6e91abff6eb96"  # Replace with valid AMI for us-west-1
  instance_type = "t2.micro"
  tags = {
    Name = "EC2-Account1"
  }
}

resource "aws_instance" "ec2_account2" {
  provider      = aws.account2
  ami           = "ami-0e35ddab05955cf57"  # Replace with valid AMI for us-east-1
  instance_type = "t2.micro"
  tags = {
    Name = "EC2-Account2"
  }
}

