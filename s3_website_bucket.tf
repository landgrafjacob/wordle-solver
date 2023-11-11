resource "aws_s3_bucket" "website" {
  bucket = "wordle-solver-website-bucket"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id
  index_document {
    suffix = "index.html"
  }
}

module "website_files" {
  source = "hashicorp/dir/template"
  base_dir = "${path.module}/website"
}

resource "aws_s3_object" "website" {
  bucket = aws_s3_bucket.website.id
  for_each = module.website_files.files
  key = each.key
  source = each.value.source_path
  source_hash = each.value.digests.md5
  content_type = each.value.content_type
}