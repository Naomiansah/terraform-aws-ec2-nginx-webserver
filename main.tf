provider "aws" {
  region = "us-east-1"
}


data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_key_pair" "My-study" {
  key_name   = "My-study-key"
 public_key = file("C:/Users/Naomi Ansah/.ssh/terraform-key.pub")
}


resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
 



   egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
   
  }


   ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks      = ["41.155.15.162/32"]
  
    
  }

ingress {
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}


  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amzn-linux-2023-ami.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.My-study.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  user_data = file("userdata.sh")

  tags = {
    Name = "Terraform-Web-Server"
  }
}

