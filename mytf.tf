provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "my_instance" {
  ami                    = "ami-03aefa83246f44ef2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data              = file("docker_op.sh")
  key_name               = "demo"
}

resource "aws_eip" "static_eip" {
  instance = aws_instance.my_instance.id
}

output "instance_id" {
  value = aws_instance.my_instance.id
}

output "instance_public_ip" {
  value = aws_eip.static_eip.public_ip
}

resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "My security group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
