data "aws_route53_zone" "solvethewordle" {
  name         = "solvethewordle.com"
  private_zone = false
}

resource "aws_route53_record" "dev" {
  name    = "dev.${data.aws_route53_zone.solvethewordle.name}"
  type    = "A"
  zone_id = data.aws_route53_zone.solvethewordle.zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.wordle_solver.domain_name
    zone_id                = aws_cloudfront_distribution.wordle_solver.hosted_zone_id
  }
}