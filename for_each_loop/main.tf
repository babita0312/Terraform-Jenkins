resource "aws_instance" "demo_tf" {
  ami                    = "ami-002f6e91abff6eb96"
  instance_type          = "t2.micro"
  count = 1
 
   tags = {
    Name = "count-loop-instance"
  }
}

resource "aws_iam_user" "iam" {
  for_each = var.user_name
  name = each.value
}

variable "user_name" {
    description = "IAM user name"
    type = set(string)
    default = [ "value1" ,"value2","value3", "value1" ]
  
}