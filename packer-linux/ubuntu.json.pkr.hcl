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
  default = "mupando-ubuntu-packer-ami"
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

variable "apache_zip" {
  type    = string
  default = "../hashicorp/packer/assets/index.html"
}

variable "tags" {
  type = map(string)
  default = {
    "Name"        = "Mupando Ubuntu Packer Image"
    "Environment" = "Production"
    "OS_Version"  = "Ubuntu 22.04"
    "Release"     = "Latest"
    "Created-by"  = "Packer"
  }
}

variable "ami_regions" {
  default = ["eu-west-2"]
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

source "null" "ubuntu" {
  communicator = "none"
}

source "amazon-ebs" "ubuntu" {
  ami_name        = "${var.ami_prefix}-${local.timestamp}"
  ami_description = "Ubuntu Image from Packer build demo"
  region          = "eu-west-2"
  vpc_id          = var.vpc_id
  subnet_id       = var.subnet_id
  instance_type   = "t2.medium"
  skip_create_ami             = true
  source_ami                  = data.amazon-ami.ubuntu-ami.id
  associate_public_ip_address = true
  ssh_username                = "ubuntu"
  tags                        = var.tags
}

build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "echo Installing Updates",
      "sudo apt-get update -y",
      "sudo apt-get upgrade -y",
      "sudo apt-get install -y nginx"
    ]
    pause_before = "10s"
  }

  provisioner "file" {
    source      = "assets"
    destination = "/tmp"
  }

  provisioner "breakpoint" {
    disable = true
    note    = "validate files are uploaded"
  }

  provisioner "shell" {
    inline = [
      "echo Installing webserver",
      "sudo cp /tmp/assets/index.html /var/www/html/index.html",
      "sudo cp /tmp/assets/index.jpg /var/www/html/index.jpg",
      "sudo chown www-data:www-data /var/www/html",
      "sudo chmod 644 /var/www/html"
    ]
  }

  post-processor "manifest" {
    output = "./manifest-ubuntu.json"
  }
}
