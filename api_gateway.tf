# API Gateway execution role
data "aws_iam_policy_document" "api_gateway_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "api_gateway" {
  statement {
    effect = "Allow"
    actions = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website.arn}/*"]
  }
}

resource "aws_iam_policy" "api_gateway" {
  name = "WordleSolverAPIGatewayPolicy"
  description = "Policy to allow wordle-solver API Gateway to access resources"
  policy = data.aws_iam_policy_document.api_gateway.json
}

resource "aws_iam_role" "api_gateway" {
  name = "WordleSolverAPIGatewayRole"
  assume_role_policy = data.aws_iam_policy_document.api_gateway_assume_role.json
}

resource "aws_iam_role_policy_attachment" "api_gateway" {
  role = aws_iam_role.api_gateway.name
  policy_arn = aws_iam_policy.api_gateway.arn
}

resource "aws_api_gateway_rest_api" "wordle_solver" {
  name = "wordle-solver"
}

resource "aws_api_gateway_method" "root" {
  rest_api_id = aws_api_gateway_rest_api.wordle_solver.id
  resource_id = aws_api_gateway_rest_api.wordle_solver.root_resource_id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "root" {
  http_method = aws_api_gateway_method.root.http_method
  resource_id = aws_api_gateway_rest_api.wordle_solver.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.wordle_solver.id
  type        = "AWS"
  uri         = "arn:aws:apigateway:${data.aws_region.current.name}:s3:path/${aws_s3_bucket.website.bucket}/index.html"
  credentials = aws_iam_role.api_gateway.arn
  integration_http_method = aws_api_gateway_method.root.http_method
}

