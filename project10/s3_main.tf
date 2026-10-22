# Create S3 Bucket
resource "aws_s3_bucket" "project_bucket" {
  bucket = "hr82project10-s3-bucket"

  tags = {
    Name = "hr82project10-s3-bucket"
  }
}

# Enable Versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.project_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
