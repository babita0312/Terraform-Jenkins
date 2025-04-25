resource "aws_instance" "demo_tf" {
  ami                         = "ami-002f6e91abff6eb96"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "tf-demo"
  vpc_security_group_ids      = [aws_security_group.main.id]

  tags = {
    Name = "AnsibleMaster"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/Admin/Downloads/demo/tf-demo.pem")
    host        = self.public_ip
  }

  provisioner "file" {
    content     = <<EOF
[slaves]
slave ansible_host=${var.slave_ip} ansible_user=ec2-user ansible_ssh_private_key_file=/home/ec2-user/ansible_master.pem
EOF
    destination = "/home/ec2-user/inventory"
  }

  provisioner "file" {
    source      = "C:/Users/Admin/Downloads/demo/ansible_master.pem"
    destination = "/home/ec2-user/ansible_master.pem"
  }

  provisioner "file" {
    content     = <<EOF
---
- name: Ping Slave
  hosts: slaves
  tasks:
    - name: Ping
      ping:
EOF
    destination = "/home/ec2-user/ping.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo dnf install -y ansible", #If you want to keep using Amazon Linux 2023, you'll have to install Ansible via dnf:
      # "amazon-linux-extras install ansible2 -y",  # AMI ID with Amazon Linux 2
      "chmod 400 /home/ec2-user/ansible_master.pem",
      "ansible-playbook -i /home/ec2-user/inventory /home/ec2-user/ping.yaml"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("C:/Users/Admin/Downloads/demo/tf-demo.pem")
      host        = self.public_ip
    }
  }
}

variable "slave_ip" {
  type        = string
  description = "Private or Public IP of manually created slave EC2 instance 13.203.219.181"
}


resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
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
  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    },

    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    }
  ]
}

