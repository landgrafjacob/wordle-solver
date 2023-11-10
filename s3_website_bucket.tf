resource "aws_s3_bucket" "website" {
  bucket = "wordle-solver-website-bucket"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "website" {
  bucket = aws_s3_bucket.website.id
  for_each = fileset("${path.module}/website", "**")
  key = each.value
  source = "${path.module}/website/${each.value}"
  source_hash = filemd5("${path.module}/website/${each.value}")
  context_type = "text/html"
}