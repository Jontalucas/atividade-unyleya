provider "aws" {
  region = "us-east-1"
  shared_credentials_files = ["D:/Unyleya/Melhores práticas em devops/Projeto unidade 4/credentials.txt"]
  profile = "Jontalucas"
}

resource "aws_instance" "atividade" {
  ami = "${data.aws_ami.windows-2019.id}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.my-key.key_name}"
  security_groups = ["${resource.aws_security_group.allow_access.name}", "${resource.aws_security_group.allow_ssh.name}"]
}

data "aws_ami" "windows-2019" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base*"]
  }
}

resource "aws_key_pair" "my-key" {
  key_name = "my-key"
  public_key = "${file("D:/Unyleya/Melhores práticas em devops/Projeto unidade 4/pub_key.pub")}"
}

resource "aws_security_group" "allow_access" {
  name = "allow_access"
  ingress{
    from_port = 3389
	to_port = 3389
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
	
  }
  egress {
    from_port = 0
	to_port = 0
	protocol = -1
	cidr_blocks =["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  ingress{
    from_port = 22
	to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
	
  }
  egress {
    from_port = 0
	to_port = 0
	protocol = -1
	cidr_blocks =["0.0.0.0/0"]
  }
}

output "atividade_public_dns" {
  value = "${aws_instance.atividade.public_dns}"
}