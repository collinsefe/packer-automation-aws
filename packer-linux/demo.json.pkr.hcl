packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}


locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

variable "ami_prefix" {
  type    = string
  default = "mupando-demo-packer-ubuntu-aws"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "description of the `foo` variable"
}

variable "tags" {
  type = map(string)
  default = {
    "Name"        = "Mupando Demo Ubuntu Packer Image"
    "Environment" = "Production"
    "OS_Version"  = "Ubuntu 22.04"
    "Release"     = "Latest"
    "Created-by"  = "Packer"
  }
}



variable "region" {
  default = "eu-west-2"
}


data "amazon-ami" "ubuntu-ami" {
  filters = {
    virtualization-type = "hvm"
    name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
    root-device-type    = "ebs"
  }
  owners      = ["amazon"]
  most_recent = true
}

source "amazon-ebs" "ubuntu" {
  ami_name        = "${var.ami_prefix}-${local.timestamp}"
  ami_description = "Ubuntu Image from Packer build demo"
  instance_type   = "t2.medium"
  subnet_id = "subnet-080be922806ba9147"
vpc_id = "vpc-0a878b83e5183e49c"
  region          = var.region
  source_ami      = data.amazon-ami.ubuntu-ami.id
  skip_create_ami = false
  ssh_username    = "ubuntu"
  tags            = var.tags
#   ami_wait_timeout = "30m" 
}



build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]



  provisioner "shell" {
    inline = [
      "echo Installing Updates",
      "whoami",
      "sudo apt-get update -y",
      "sudo apt-get upgrade -y",
      "sudo apt-get install -y nginx",
      "sudo chown -R www-data:www-data /var/www/html",
      "sudo chmod -R 755 /var/www/html",
      "sudo systemctl reload nginx"
    ]
  }

  provisioner "file" {
    source      = "assets"
    destination = "/tmp"
  }

    provisioner "shell" {
  inline = [
    "echo Installing webserver",
    "sudo cp /tmp/assets/index.html /var/www/html/index.html",
    "sudo cp /tmp/assets/index.jpg /var/www/html/index.jpg",
    "sudo systemctl reload nginx"
  ]
}

  post-processor "manifest" {
    output = "./manifest-demo.json"
    strip_path = true
    custom_data = {
    my_custom_data = "example"
    }
}

}

