terraform {
  backend "s3" {}
}

locals {
  domain = "sherminho.com"
}

# --- S3 static website ---

resource "aws_s3_bucket" "site" {
  bucket = local.domain
}

resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  index_document { suffix = "index.html" }
  error_document { key = "index.html" }
}

resource "aws_s3_bucket_policy" "site" {
  bucket     = aws_s3_bucket.site.id
  depends_on = [aws_s3_bucket_public_access_block.site]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.site.arn}/*"
    }]
  })
}

# --- Route 53 ---

resource "aws_route53_zone" "zone" {
  name = local.domain
}

resource "aws_route53_record" "site" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = local.domain
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.site.website_domain
    zone_id                = aws_s3_bucket.site.hosted_zone_id
    evaluate_target_health = false
  }
}
