# ENI

resource "aws_network_interface" "raido-rec" {
  subnet_id       = aws_subnet.public_subnet_1a.id
  security_groups = [aws_security_group.radio_sg.id]

  tags = {
    Name = "radio"
  }
}

# EC2

data "aws_ssm_parameter" "amzn2_latest_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "raido-rec" {
  ami           = "ami-00e367305e917375d"
  instance_type = "t3.large"
  #instance_type           = "t2.micro"
  disable_api_termination = false
  monitoring              = false
  key_name                = "radio"
  network_interface {
    network_interface_id = aws_network_interface.raido-rec.id
    device_index         = 0
  }
}

# output　メモ：出力は見通し悪ければ、ファイル分割する

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.raido-rec.id
}

output "public_dns" {
  description = "public DNS ipv4"
  value       = aws_instance.raido-rec.public_dns
}


output "server_public_ip" {
  description = "The public IP address assigned to the instanceue"
  value       = aws_instance.raido-rec.public_ip
}

