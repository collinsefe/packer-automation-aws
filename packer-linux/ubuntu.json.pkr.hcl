packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 1"
    }
  }
}


locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

variable "ami_prefix" {
  type    = string
  default = "mupando-packer-ubuntu-aws"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "description of the `foo` variable"
}


variable "apache_zip" {
  type    = string
  default = "../hashicorp/packer/assets/index.html"
}

variable "ami_name" {
  type    = string
  default = "the default value of the `foo` variable"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0a878b83e5183e49c"

}

variable "subnet_id" {
  type    = string
  default = "subnet-080be922806ba9147"
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
    name                = "ubuntu/images/*/*ubuntu-noble-24.04-amd64-server-*"
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
  vpc_id          = var.vpc_id
  subnet_id       = var.subnet_id
  instance_type   = "t2.micro"
  region          = "eu-west-2"
  #   ami_regions     = var.ami_regions
  skip_create_ami = true
  #   boot_encryption = true
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
    pause_before = "30s"
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
