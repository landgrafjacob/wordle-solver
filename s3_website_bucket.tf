resource "aws_s3_bucket" "website" {
  bucket = "wordle-solver-website-bucket"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.website.json
}

data "aws_iam_policy_document" "website" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
    actions = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website.arn}/*"]
    condition {
      test     = "ArnLike"
      values   = ["${aws_api_gateway_rest_api.wordle_solver.execution_arn}/*/GET/"]
      variable = "aws:SourceArn"
    }
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