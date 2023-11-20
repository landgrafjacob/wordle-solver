resource "aws_acm_certificate" "solvethewordle" {
  domain_name       = "dev.solvethewordle.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "solvethewordle" {
  name         = "solvethewordle.com"
  private_zone = false
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.example.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.solvethewordle.zone_id
}

resource "aws_acm_certificate_validation" "solvethewordle" {
  certificate_arn         = aws_acm_certificate.solvethewordle.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}

resource "aws_route53_record" "dev" {
  name    = aws_api_gateway_domain_name.wordle_solver.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.solvethewordle.zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.wordle_solver.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.wordle_solver.cloudfront_zone_id
  }
}