
terraform {
  backend "s3" {
    bucket = "hr82project10-s3-bucket"
    key    = "ec2/terraform.tfstate"
    region = "ap-south-1"
  }
}
