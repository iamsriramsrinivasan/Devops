//Its better to use variables for sensitive values and also commonly used values like region

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "key_name" {}
variable "region" {
  default = "us-east-2"
}

//We are giving our aws credintials 
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

//Key data that is required for us to create an instance
data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


#This uses the default VPC.  It WILL NOT delete it on destroy.
resource "aws_default_vpc" "default" {

}

//lets create our aws security group.
resource "aws_security_group" "allow_ssh" {
  name        = "lamp_server"
  description = "Allow ports for webserver"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//we are going for the free tier eligible instance and giving the vpc parameters
//and ssh parameters to connect to that instance.
resource "aws_instance" "lamp" {
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)

  }

  provisioner "remote-exec" {
    inline = [
     "sudo yum -y install httpd",
     "sudo service httpd start",
     "sudo yum -y install mysql",
     "sudo yum -y install php php-mysql"
     ]
  }
 }


//execute these commands on the aws ec2 instance we have created above
output "aws_instance_public_dns" {
  value = aws_instance.lamp.public_dns
}
