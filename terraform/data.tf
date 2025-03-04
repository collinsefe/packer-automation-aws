data "aws_ami" "source_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "name"
    values = ["mupando-demo-packer-ubuntu-aws-*"]
  }
  

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

