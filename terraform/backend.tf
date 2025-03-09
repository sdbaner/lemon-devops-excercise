terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-lemon"
    key    = "terraform.tfstate"
    region = "eu-central-1"
    
    # enable state locking with dynamoDB
  }
}
