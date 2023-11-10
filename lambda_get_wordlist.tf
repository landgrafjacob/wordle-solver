data "aws_iam_policy_document" "get_wordlist_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "get_wordlist" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = [
      "${aws_s3_bucket.data_bucket.arn}*"
    ]
  }
}

resource "aws_iam_policy" "get_wordlist" {
  name        = "GetWordlistPolicy"
  description = "Execution role for get-wordlist lambda function"
  policy      = data.aws_iam_policy_document.get_wordlist.json
}

resource "aws_iam_role_policy_attachment" "get_wordlist" {
  role       = aws_iam_role.get_wordlist.name
  policy_arn = aws_iam_policy.get_wordlist.arn
}

resource "aws_iam_role" "get_wordlist" {
  name               = "GetWordListRole"
  assume_role_policy = data.aws_iam_policy_document.get_wordlist_assume_role.json
}

data "archive_file" "get_wordlist" {
  type        = "zip"
  source_file = "${path.module}/python/get_wordlist.py"
  output_path = "${path.module}/python/get_wordlist.zip"
}

resource "aws_lambda_function" "get_wordlist" {
  function_name = "get-wordlist"
  role          = aws_iam_role.get_wordlist.arn
  filename      = data.archive_file.get_wordlist.output_path

  environment {
    variables = {
      WORDLIST_OBJECT = aws_s3_bucket.data_bucket.bucket
      WORDLIST_OBJECT = aws_s3_object.wordlist.key
    }
  }
}