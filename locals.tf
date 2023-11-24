locals {
  stage_name            = "v1"
  s3_origin_id          = "WordleSolverS3Origin"
  api_gateway_origin_id = "WordleSolverAPIGOrigin"
  domain_name = "dev.${data.aws_route53_zone.solvethewordle.name}"
}