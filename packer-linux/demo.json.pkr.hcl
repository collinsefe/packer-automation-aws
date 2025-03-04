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

variable "iam_instance_profile_name" {
  type    = string
  default = "mp-packer-profile"
}

variable "security_group_id" {
  type    = string
  default = "sg-0cc1ea54dcf9a5628"
}

variable "subnet_id" {
  type    = string
  default = "subnet-0b3b943b67728deb5"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0a878b83e5183e49c"
}

variable "instance_type" {
  type    = string
  default = "t2.medium"
}

variable "ami_prefix" {
  type    = string
  default = "mupando-demo-packer-ubuntu-ami"
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
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id 
  vpc_id          = var.vpc_id  
  region          = var.region
  security_group_id = var.security_group_id
  source_ami      = data.amazon-ami.ubuntu-ami.id
  skip_create_ami = true
  ssh_username    = "ubuntu"
  tags            = var.tags
  ssh_timeout     = "30m"
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

    provisioner "breakpoint" {
    disable = true
    note    = "validate files are uploaded"
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
  }
}


