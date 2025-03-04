packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
    windows-update = {
      version = "0.15.0"
      source  = "github.com/rgl/windows-update"
    }
  }
}


data "amazon-ami" "aws-windows-ssh" {
  filters = {
    name                = "Windows_Server-2022-English-Full-Base-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["amazon"]
}

variable "ami_id" {
  type    = string
  default = "ami-0c2e82530874663e5"
}

variable "destination_regions" {
  type    = string
  default = "eu-west-1,eu-west-2,eu-west-3"
}

variable "security_group_id" {
  type    = string
  default = "sg-0904a88db2992d41d"
}

variable "subnet_id" {
  type    = string
  default = "subnet-01c64982492a3175c"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0c66e7b4f002ea43e"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "ebs" {
  ami_description       = "Mupando Custom Windows AMI built by Packer"
  ami_name              = "mupando-windows-packer-ami-${local.timestamp}"
  subnet_id             = "subnet-0b3b943b67728deb5"
  vpc_id                = "vpc-0a878b83e5183e49c"
  security_group_id     = "sg-0cc1ea54dcf9a5628"
  force_delete_snapshot = "true"
  force_deregister      = "true"
  iam_instance_profile  = "mp-packer-profile"
  instance_type         = "t2.medium"
  skip_create_ami             = true
  region                      = "eu-west-2"
  source_ami                  = data.amazon-ami.aws-windows-ssh.id 
  ami_virtualization_type     = "hvm"
  associate_public_ip_address = true
  communicator                = "ssh"
  ssh_timeout                 = "10m"
  ssh_username                = "Administrator"
  ssh_file_transfer_method    = "sftp"
  user_data_file              = "files/setupssh.ps1"
  fast_launch {
    enable_fast_launch = true
  }
  snapshot_tags = {
    Name      = "mupando-windows-packer-instance"
    BuildTime = "${local.timestamp}"
  }

  tags = {
    Name      = "mupando-windows-packer-ami-${local.timestamp}"
    BuildTime = "${local.timestamp}"
  }
}

build {
  sources = ["source.amazon-ebs.ebs"]

  provisioner "windows-update" {}
§§
  provisioner "powershell" {
    script = "files/windows1-install.ps1"
  }

  provisioner "windows-restart" {
  }

  provisioner "powershell" {
    script = "files/prepareimage.ps1"
  }

}