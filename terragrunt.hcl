remote_state {
  backend = "s3"
  config = {
    bucket         = "<YOUR_BUCKET_NAME>"
    key            = "<YOUR_KEY>"
    region         = "<YOUR_REGION>"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
