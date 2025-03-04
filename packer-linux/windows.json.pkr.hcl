# This is a comment

packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}


data "amazon-ami" "windows_2022" {
  filters = {
    name = "Windows_Server-2022-English-Full-Base-*"
  }
  most_recent = true
  owners      = ["amazon"]
  region      = "eu-west-2"
}


locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "mp" {
  ami_description = "Mupando Custom AMI built by Packer"
  ami_name        = "mupando-windows-packer-ami-${local.timestamp}"
  user_data_file  = "./files/bootstrap-windows.txt"
  communicator    = "winrm"
  subnet_id       = "subnet-080be922806ba9147"
  vpc_id          = "vpc-0a878b83e5183e49c"
  # vpc_id                = "vpc-0c66e7b4f002ea43e" #var.vpc_id
  # subnet_id             = "subnet-01c64982492a3175c"  #var.subnet_id
  force_delete_snapshot = "true"
  force_deregister      = "true"
  # iam_instance_profile  = "mp-packer-profile"
  instance_type               = "t2.medium"
  region                      = "eu-west-2"
  associate_public_ip_address = true
  skip_create_ami             = true
  winrm_insecure              = true
  winrm_use_ssl               = true
  source_ami                  = "${data.amazon-ami.windows_2022.id}"
  winrm_username              = "Administrator"
  winrm_password              = "SuperS3cr3t!!!!"
  tags = {
    "Name"        = "MyWindowsImage"
    "Environment" = "Production"
    "OS_Version"  = "Windows"
    "Release"     = "Latest"
    "Created-by"  = "Packer"
  }
}


build {
  sources = ["source.amazon-ebs.mp"]


  provisioner "shell" {
    # This provisioner only runs for the 'first-example' source.
    # only = ["amazon-ebs.first-example"]

    inline = [
      "echo provisioning all the things"
    ]
  }
  provisioner "shell" {
    # This runs with all sources.
    inline = [
      "echo Hi World!"
    ]
  }

  post-processors {
    post-processor "shell-local" { # create an artifice.txt file containing "hello"
      inline = ["echo hello > artifice.txt"]
    }
    post-processor "artifice" { # tell packer this is now the new artifact
      files = ["artifice.txt"]
    }
    /*
    post-processor "checksum" {               # checksum artifice.txt
      checksum_types      = ["md5", "sha512"] # checksum the artifact
      keep_input_artifact = true              # keep the artifact
    }*/
  }
}
# source "amazon-ebs" "windows_2019" {
#   ami_name       = "my-windows-2019-aws-{{timestamp}}"
#   communicator   = "winrm"
#   instance_type  = "t3.micro"
#   region         = "us-east-1"
#   source_ami     = "${data.amazon-ami.windows_2019.id}"
#   user_data_file = "./scripts/SetUpWinRM.ps1"
#   winrm_insecure = true
#   winrm_use_ssl  = true
#   winrm_username = "Administrator"
#   tags = {
#     "Name"        = "MyWindowsImage"
#     "Environment" = "Production"
#     "OS_Version"  = "Windows"
#     "Release"     = "Latest"
#     "Created-by"  = "Packer"
#   }
# }

# source "amazon-ebs" "windows_2022" {
#   ami_name       = "my-windows-2022-aws-{{timestamp}}"
#   communicator   = "winrm"
#   instance_type  = "t3.micro"
#   region         = "us-east-1"
#   source_ami     = "${data.amazon-ami.windows_2022.id}"
#   user_data_file = "./scripts/SetUpWinRM.ps1"
#   winrm_insecure = true
#   winrm_use_ssl  = true
#   winrm_username = "Administrator"
# }

/*
data "amazon-ami" "first-example" {
  filters = {
    virtualization-type = "hvm"
    name                = "ubuntu/images/hvm-ssd-gp3/*ubuntu-noble-24.04-amd64-server-*"
    root-device-type    = "ebs"
  }
  owners      = ["amazon"]
  most_recent = true
}
*/
