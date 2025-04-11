resource "aws_instance" "web1" {
  ami           = var.ami_id1
  instance_type = var.instance_type
  count = 2 

  tags = {
    Name = "Server ${count.index}"
  }
  provider = aws.ap-south-1
}

resource "aws_ebs_volume" "web1_ebs" {
  availability_zone = var.web1_ebs_zone
  size = var.web1_ebs_size
  
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.web1_ebs.id
  instance_id = aws_instance.web1[0].id

  depends_on = [ 
    aws_ebs_volume.web1_ebs 
    ]
}

/*resource "aws_instance" "web2" {
  ami           = var.ami_id2
  instance_type = var.instance_type

  tags = {
    Name = "PROD-1"
  }

  provider = aws.us-east-1
}*/

resource "aws_s3_bucket" "state_bucket" {
  bucket = "terraform-state-prod-5312663"

  tags = {
    Name        = "State bucket"
    Environment = "PROD"
  }
}

