# data "amazon-parameterstore" "basic-example" {
#   name = "packer_test_parameter"
#   with_decryption = false

#   assume_role {
#       role_arn     = "arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME"
#       session_name = "SESSION_NAME"
#       external_id  = "EXTERNAL_ID"
#   }
# }


# data "amazon-secretsmanager" "basic-example" {
#   name = "packer_test_secret"
#   key  = "packer_test_key"

#   assume_role {
#       role_arn     = "arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME"
#       session_name = "SESSION_NAME"
#       external_id  = "EXTERNAL_ID"
#   }
# }


# data "amazon-ami" "basic-example" {
#     filters = {
#         virtualization-type = "hvm"
#         name = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
#         root-device-type = "ebs"
#     }
#     owners = ["099720109477"]
#     most_recent = true
# }


# data "amazon-secretsmanager" "basic-example" {
#   name = "packer_test_secret"
#   key  = "packer_test_key"

#   assume_role {
#       role_arn     = "arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME"
#       session_name = "SESSION_NAME"
#       external_id  = "EXTERNAL_ID"
#   }
# }


