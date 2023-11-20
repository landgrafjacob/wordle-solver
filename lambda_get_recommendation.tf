data "aws_iam_policy_document" "get_recommendation_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "get_recommendation" {
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

resource "aws_iam_policy" "get_recommendation" {
  name        = "GetRecommendationPolicy"
  description = "Execution role for get-recommendation lambda function"
  policy      = data.aws_iam_policy_document.get_recommendation.json
}

resource "aws_iam_role" "get_recommendation" {
  name               = "GetRecommendationExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.get_recommendation_assume_role.json
}

resource "aws_iam_role_policy_attachment" "get_recommendation" {
  role       = aws_iam_role.get_recommendation.name
  policy_arn = aws_iam_policy.get_recommendation.arn
}

# Lambda permission
resource "aws_lambda_permission" "get_recommendation" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_recommendation.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.wordle_solver.execution_arn}/*"
}

data "archive_file" "get_recommendation" {
  type        = "zip"
  source_file = "${path.module}/python/get_recommendation.py"
  output_path = "${path.module}/python/get_recommendation.zip"
}

resource "aws_lambda_function" "get_recommendation" {
  function_name = "get-recommendation"
  role          = aws_iam_role.get_recommendation.arn
  filename      = data.archive_file.get_recommendation.output_path
  handler       = "get_recommendation.lambda_handler"
  runtime       = "python3.10"

  environment {
    variables = {
      FREQ_BUCKET = aws_s3_bucket.data_bucket.bucket
      FREQ_OBJECT = aws_s3_object.letter_frequencies.key
    }
  }
}