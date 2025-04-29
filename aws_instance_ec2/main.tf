resource "aws_instance" "demo_tf" {
  ami                         = "ami-002f6e91abff6eb96"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "tf-demo"
  vpc_security_group_ids      = [aws_security_group.main.id]

  depends_on = [aws_security_group.main] # ensure SG is ready

  tags = {
    Name = "AnsibleMaster"
  }

  connection {
    type         = "ssh"
    user         = "ec2-user"
    private_key  = file("C:/Users/Admin/Downloads/demo/tf-demo.pem")
    host         = self.public_ip
    timeout      = "2m" # wait for SSH to come up
    bastion_host = null
  }

  provisioner "file" {
    content     = <<EOF
[slaves]
slave ansible_host=${var.slave_ip} ansible_user=ec2-user ansible_ssh_private_key_file=/home/ec2-user/ansible_master.pem
EOF
    destination = "/home/ec2-user/inventory"

    on_failure = continue
  }

  provisioner "file" {
    source      = "C:/Users/Admin/Downloads/demo/ansible_master.pem"
    destination = "/home/ec2-user/ansible_master.pem"

    on_failure = continue

  }

  provisioner "file" {
    content     = <<EOF
---
- name: Ping Slave
  hosts: slaves
  tasks:
    - name: upgrade packages
      ansible.builtin.yum:
        name: nginx       
        state: present
        update_cache: yes
EOF
    destination = "/home/ec2-user/ping.yaml"

    on_failure = continue
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 30", # Wait for EC2 readiness (good practice)
      "sudo yum update -y",
      "sudo dnf install -y python3-pip",
      "pip3 install ansible",
      "chmod 400 /home/ec2-user/ansible_master.pem",
      "ansible --version",
      "ansible-playbook -i /home/ec2-user/inventory /home/ec2-user/ping.yaml"
    ]

    on_failure = continue

  }
}

variable "slave_ip" {
  type        = string
  description = "Private or Public IP of manually created slave EC2 instance 43.204.229.105"
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

