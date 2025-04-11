resource "aws_instance" "demo_tf" {
  ami                    = "ami-002f6e91abff6eb96"
  instance_type          = "t2.micro"
     

  provisioner "local-exec" {
    /*command = "touch hello-jhooq.txt" */
    command = "type nul > hello-jhooq.txt"      # This creates an empty file just like touch would, but using Windows syntax

  }

   tags = {
    Name = "demo-instance"
  }
}