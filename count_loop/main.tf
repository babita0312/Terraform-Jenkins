resource "aws_instance" "demo_tf" {
  ami                    = "ami-002f6e91abff6eb96"
  instance_type          = "t2.micro"
  count = 1
 
   tags = {
    Name = "count-loop-instance"
  }
}

resource "aws_iam_user" "iam" {
  count = length(var.user_name)
  name = var.user_name[count.index]
}

variable "user_name" {
    description = "IAM user name"
    type = list(string)
    default = [ "value1" ,"value2","value3" ]
  
}