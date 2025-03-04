# resource "aws_rbin_rule" "example" {
#   description   = "example_rule"
#   resource_type = "EBS_SNAPSHOT"

#   resource_tags {
#     resource_tag_key   = "tag_key"
#     resource_tag_value = "tag_value"
#   }

#   retention_period {
#     retention_period_value = 10
#     retention_period_unit  = "DAYS"
#   }

#   tags = {
#     "test_tag_key" = "test_tag_value"
#   }
# }