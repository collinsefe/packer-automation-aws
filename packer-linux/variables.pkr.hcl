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
