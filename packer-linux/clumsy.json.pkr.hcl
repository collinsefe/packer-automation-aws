packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
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

source "amazon-ebs" "ubuntu" {
  ami_name      = "mupando-packer-ubuntu-aws-{{timestamp}}"
  instance_type = "t3.micro"
  region        = "eu-west-2"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username = "ubuntu"
  tags = var.tags
}

build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "echo Installing Updates",
      "sudo apt-get update",
      "sudo apt-get upgrade -y"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo Testing"
    ]
  }

  provisioner "breakpoint" {
    disable = false
    note    = "inspect before installing nginx"
  }

  provisioner "shell" {
    inline = [
      "sudo apt-get install -y nginx"
    ]
  }

  provisioner "breakpoint" {
    disable = false
    note    = "validate after installing nginx"
  }

  provisioner "file" {
    source      = "assets"
    destination = "/tmp/"
  }

  provisioner "breakpoint" {
    disable = false
    note    = "validate files are uploaded"
  }

  post-processor "manifest" {}

}