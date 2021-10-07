provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "cyber94-asaleh-bucket"
    key = "tfstate/calculator/terraform.tfstate"
    region = "eu-west-1"
    dynamodb_table = "cyber94_calculator_asaleh_dynamodb_table_lock"
    encrypt = true
  }
}

resource "aws_vpc" "cyber94_fullinfra_asaleh_vpc_tf"{
  cidr_block ="10.101.0.0/16"

  tags ={
    Name = "cyber94_fullinfra_asaleh_vpc"
  }
}

resource "aws_internet_gateway" "cyber94_fullinfra_asaleh_igw_tf" {
    vpc_id = aws_vpc.cyber94_fullinfra_asaleh_vpc_tf.id

    tags ={
      Name = "aws_internet_gateway.cyber94_fullinfra_asaleh_igw"
    }
}

resource "aws_route_table" "cyber94_fullinfra_asaleh_rt_tf" {
  vpc_id = aws_vpc.cyber94_fullinfra_asaleh_vpc_tf.id

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cyber94_fullinfra_asaleh_igw_tf.id
  }

  tags = {
    Name = "cyber94_fullinfra_asaleh_internet_rt"
  }
}

resource "aws_subnet" "cyber94_fullinfra_asaleh_subnet_app_tf" {
  vpc_id = aws_vpc.cyber94_fullinfra_asaleh_vpc_tf.id
  cidr_block = "10.101.1.0/24"

  tags = {
    Name = "cyber94_fullinfra_asaleh_subnet_app"
  }
}
resource "aws_subnet" "cyber94_fullinfra_asaleh_subnet_db_tf" {
  vpc_id = aws_vpc.cyber94_fullinfra_asaleh_vpc_tf.id
  cidr_block = "10.101.2.0/24"

  tags = {
    Name = "cyber94_fullinfra_asaleh_subnet_db"
  }
}
resource "aws_subnet" "cyber94_fullinfra_asaleh_subnet_bast_tf" {
  vpc_id = aws_vpc.cyber94_fullinfra_asaleh_vpc_tf.id
  cidr_block = "10.101.3.0/24"

  tags = {
    Name = "cyber94_fullinfra_asaleh_subnet_bast"
  }
}

resource "aws_route_table_association" "cyber94_fullinfra_asaleh_internet_rt_assoc_app_tf" {
    subnet_id = aws_subnet.cyber94_fullinfra_asaleh_subnet_app_tf.id
    route_table_id = aws_route_table.cyber94_fullinfra_asaleh_rt_tf.id
}

resource "aws_route_table_association" "cyber94_fullinfra_asaleh_internet_rt_assoc_bast_tf" {
    subnet_id = aws_subnet.cyber94_fullinfra_asaleh_subnet_bast_tf.id
    route_table_id = aws_route_table.cyber94_fullinfra_asaleh_rt_tf.id
}


resource "aws_network_acl" "cyber94_fullinfra_asaleh_nacl_app_tf" {
    vpc_id = aws_vpc.cyber94_fullinfra_asaleh_vpc_tf.id
    subnet_ids = [aws_subnet.cyber94_fullinfra_asaleh_subnet_app_tf.id]
    egress {
      protocol   = "tcp"
      rule_no    = 1000
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 3306
      to_port    = 3306
    }
  egress {
      protocol   = "tcp"
      rule_no    = 2000
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 80
      to_port    = 80
    }
  egress {
      protocol   = "tcp"
      rule_no    = 3000
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 443
      to_port    = 443
    }

  egress {
      protocol   = "tcp"
      rule_no    = 4000
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
    }

  ingress {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 5000
      to_port    = 5000
    }
  ingress {
      protocol   = "tcp"
      rule_no    = 200
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 22
      to_port    = 22
    }
  ingress {
      protocol   = "tcp"
      rule_no    = 300
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
    }
    tags = {
      Name = "cyber94_fullinfra_asaleh_nacl_app"
    }
}

resource "aws_network_acl" "cyber94_fullinfra_asaleh_nacl_db_tf" {
    vpc_id = aws_vpc.cyber94_fullinfra_asaleh_vpc_tf.id
    subnet_ids = [aws_subnet.cyber94_fullinfra_asaleh_subnet_db_tf.id]
    egress {
      protocol   = "tcp"
      rule_no    = 1000
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
    }

  ingress {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 22
      to_port    = 22
    }
  ingress {
      protocol   = "tcp"
      rule_no    = 200
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 3306
      to_port    = 3306
    }
    tags = {
      Name = "cyber94_fullinfra_asaleh_nacl_db"
    }
}

resource "aws_network_acl" "cyber94_fullinfra_asaleh_nacl_bastion_tf" {
    vpc_id = aws_vpc.cyber94_fullinfra_asaleh_vpc_tf.id
    subnet_ids = [aws_subnet.cyber94_fullinfra_asaleh_subnet_bast_tf.id]
    egress {
        protocol   = "tcp"
        rule_no    = 1000
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 22
        to_port    = 22
      }

    egress {
        protocol   = "tcp"
        rule_no    = 2000
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 1024
        to_port    = 65535
      }

    ingress {
        protocol   = "tcp"
        rule_no    = 100
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 22
        to_port    = 22
      }
    ingress {
        protocol   = "tcp"
        rule_no    = 200
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 1024
        to_port    = 65535
      }
    tags = {
      Name = "cyber94_fullinfra_asaleh_nacl_bast"
    }
}



resource "aws_security_group" "cyber94_fullinfra_asaleh_sg_server_public_tf" {
    name = "cyber94_fullinfra_asaleh_sg_server_public"

    vpc_id = aws_vpc.cyber94_fullinfra_asaleh_vpc_tf.id

    ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "5000"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
      Name = "cyber94_fullinfra_asaleh_sg_server_public"
    }
}
resource "aws_security_group" "cyber94_fullinfra_asaleh_sg_db_tf" {
    name = "cyber94_fullinfra_asaleh_sg_db"

    vpc_id = aws_vpc.cyber94_fullinfra_asaleh_vpc_tf.id

    ingress {
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port = 0
      to_port = 0
      protocol = -1
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "cyber94_fullinfra_asaleh_sg_db"
    }
}
resource "aws_security_group" "cyber94_fullinfra_asaleh_sg_bast_tf" {
    name = "cyber94_fullinfra_asaleh_sg_bast"

    vpc_id = aws_vpc.cyber94_fullinfra_asaleh_vpc_tf.id

    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      description = "HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "cyber94_fullinfra_asaleh_sg_bast"
    }
}

resource "aws_instance" "cyber94_fullinfra_asaleh_server_public_tf" {
    ami = "ami-0943382e114f188e8"
    instance_type = "t2.micro"
    key_name = "cyber94-asaleh"
    subnet_id = aws_subnet.cyber94_fullinfra_asaleh_subnet_app_tf.id
    vpc_security_group_ids = [aws_security_group.cyber94_fullinfra_asaleh_sg_server_public_tf.id]
    associate_public_ip_address = true

    tags = {
      Name = "cyber94_fullinfra_asaleh_server_app"
    }

    lifecycle {
      create_before_destroy = true
    }
  }

resource "aws_instance" "cyber94_fullinfra_asaleh_server_db_tf" {
      ami = "ami-0d1c7c4de1f4cdc9a"
      instance_type = "t2.micro"
      key_name = "cyber94-asaleh"
      subnet_id = aws_subnet.cyber94_fullinfra_asaleh_subnet_db_tf.id
      vpc_security_group_ids = [aws_security_group.cyber94_fullinfra_asaleh_sg_db_tf.id]
      associate_public_ip_address = true

      tags = {
        Name = "cyber94_fullinfra_asaleh_server_db"
      }

      lifecycle {
        create_before_destroy = true
      }
    }

resource "aws_instance" "cyber94_fullinfra_asaleh_server_bast_tf" {
          ami = "ami-0943382e114f188e8"
          instance_type = "t2.micro"
          key_name = "cyber94-asaleh"
          subnet_id = aws_subnet.cyber94_fullinfra_asaleh_subnet_bast_tf.id
          vpc_security_group_ids = [aws_security_group.cyber94_fullinfra_asaleh_sg_bast_tf.id]
          associate_public_ip_address = true

          tags = {
            Name = "cyber94_fullinfra_asaleh_server_db"
          }

          lifecycle {
            create_before_destroy = true
          }


      # Just to make sure that terraform will not contrinue to local-exec before the server is up
          connection {
            type = "ssh"
            user = "ubuntu"
            host = self.public_ip
            private_key = file("/home/kali/.ssh/cyber94-asaleh .pem")
        }


        # Just to make sure that terraform will not contrinue to local-exec before the server is up
          provisioner "remote-exec" {
          inline = [
            "pwd"
          ]
        }

        # To provision the server using ansible playbook
          provisioner "local-exec" {
          working_dir = "../ansible"
          command = "ansible-playbook -i ${self.public_ip}, -u ubuntu provisioner.yml"
        }
      }
  # This section is to provision the server to install docker from terraform directly

/*
connection {
      type = "ssh"
      user = "ubuntu"
      host = self.public_ip
      private_key = file("/home/kali/.ssh/cyber94-asaleh .pem")
  }

provisioner "file" {
      source = "../init-scripts/docker-install.sh"
      destination = "/home/ubuntu/docker-install.sh"
  }

provisioner "remote-exec" {
    inline = [
      "chmod 777 /home/ubuntu/docker-install.sh",
      "/home/ubuntu/docker-install.sh"
    ]
  }
*/
