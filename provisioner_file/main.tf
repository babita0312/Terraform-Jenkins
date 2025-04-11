resource "aws_instance" "demo_tf" {
  ami                    = "ami-002f6e91abff6eb96"
  instance_type          = "t2.micro"
  associate_public_ip_address = true  
  key_name               = "aws_key"
  vpc_security_group_ids = [aws_security_group.main.id]
  

  provisioner "file" {
    source      = "C:/Users/Admin/Downloads/demo/aws/test-file.txt"
    destination = "/home/ec2-user/test-file.txt"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"  #
    private_key = file("C:/Users/Admin/Downloads/demo/aws/aws_key") 
    host        = self.public_ip
    timeout     = "4m"
  }

  tags = {
    Name = "demo-instance"
  }
}

resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
 ingress                = [
   {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 22
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 22
  }
  ]
}
resource "aws_key_pair" "deployer" {
  key_name = "aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDUjpFSa99TQYRYKfnP7mhLSdZNnfJM/Han2z2ZE+HZxjY8yeB3wX/y+Xbo/5y6Yc8vj0T3a+U7msS0vzYPXciS0Gq35dVOCGO3F+A+Qh6hL+usn7R2OKNVqeBErd0Imx5Xn68Ae+mzPpXlfdJmjtj0nyGvBshTN/SSruf2Ntss1HMkQjYt8mzJIjqDTRV9/MarI5VDMCgpcBEBXiQWzSx/0rWQSg0cf9qbdA5qzLlPn5ikiUuhYJS/4XZAjtAoDq3Si6PZNqxHn4Yi5DaDC4DlOtDZRVel2aQrE/XycXv+lvnx/tL13x/FyWFO+BUHGNpdK/4CjZojFlyw57RMRpah admin@DESKTOP-7MECGEQ"
  
}