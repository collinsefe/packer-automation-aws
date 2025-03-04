resource "aws_s3_bucket" "foo" {
  bucket_prefix = "mupandopackerproject-bucket"
  force_destroy = true
}

