data "aws_route53_zone" "solvethewordle" {
  name         = "solvethewordle.com"
  private_zone = false
}

resource "aws_route53_record" "solvethewordle" {
  name    = local.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.solvethewordle.zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.wordle_solver.domain_name
    zone_id                = aws_cloudfront_distribution.wordle_solver.hosted_zone_id
  }
}

resource "aws_acm_certificate" "cert" {
  provider          = aws.acm
  domain_name       = local.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
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

resource "aws_acm_certificate_validation" "validation" {
  provider                = aws.acm
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}