variable "ami_id1" {
  description = "AMI ID for the EC2 instance - south-1"
  
}
variable "instance_type" {  
  description = "Instance type for the EC2 instancee"  
}

variable "ami_id2" {  
  description = "AMI ID for the EC2 instance - east-1"
}

variable "web1_ebs_zone" {
  description = "EBS volume south region"
}

variable "web1_ebs_size" {  
  description = "vol for south 1"
}