terraform {
  backend "s3" {
    bucket = "aft-corighose-tfstate"
    key    = "packer/infra.tfstate"
    region = "eu-west-2"
  }
}
