# This is a comment

packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

variable "foo" {
  type        = string
  default     = "the default value of the `foo` variable"
  description = "description of the `foo` variable"
  sensitive   = false
  # When a variable is sensitive all string-values from that variable will be
  # obfuscated from Packer's output.
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "mp" {
  ami_description       = "Mupando Custom AMI built by Packer"
  ami_name              = "mupando-packer-ami-${local.timestamp}"
  communicator          = "ssh"
  force_delete_snapshot = "true"
  force_deregister      = "true"
  iam_instance_profile  = "mupando-packer-profile"
  instance_type         = "t2.micro"
  region                = "eu-west-2"

  source_ami   = "ami-091f18e98bc129c4e"
  ssh_username = "ubuntu"
  /*
  subnet_id          = "subnet-085cbaa7a693fb7ba"
  vpc_id             = "vpc-0024afecefce2db51"
  security_group_ids = ["sg-0bf4e2fc944c877b1"]
  */
  tags = {
    Name = "mupando-packer-instance"
  }
  user_data_file = "user-data.sh"
}

build {
  sources = ["source.amazon-ebs.mp"]

  provisioner "shell" {
    scripts = ["user-data.sh"]
  }

  provisioner "shell" {
    # This provisioner only runs for the 'first-example' source.
    only = ["amazon-ebs.first-example"]

    inline = [
      "echo provisioning all the things",
      "echo the value of 'foo' is '${var.foo}'",
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

data "amazon-ami" "first-example" {
  filters = {
    virtualization-type = "hvm"
    name                = "ubuntu/images/hvm-ssd-gp3/*ubuntu-noble-24.04-amd64-server-*"
    root-device-type    = "ebs"
  }
  owners      = ["amazon"]
  most_recent = true
}
