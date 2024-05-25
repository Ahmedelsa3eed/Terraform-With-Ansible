data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  count         = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id
  key_name      = "saeed-project-key"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "WebServer-${count.index}"
  }
}

resource "null_resource" "write_ips" {
  triggers = {
    instance1_id = aws_instance.web[0].id
    instance2_id = aws_instance.web[1].id
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo "[webservers]" > ../inventory.ini
      echo "${aws_instance.web[0].public_ip}" >> ../inventory.ini
      echo "${aws_instance.web[1].public_ip}" >> ../inventory.ini
    EOT

    environment = {
      ip1 = aws_instance.web[0].public_ip
      ip2 = aws_instance.web[1].public_ip
    }

    working_dir = "${path.module}"
  }

  depends_on = [ aws_instance.web ]
}

resource "null_resource" "ansible" {
  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.ini wordpress.yml -e '@vars.yml'"
    working_dir = "../"
  }

  depends_on = [ null_resource.write_ips ]
}
