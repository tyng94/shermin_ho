output "website_url" {
  value = "http://${aws_s3_bucket_website_configuration.site.website_endpoint}"
}

output "route53_zone_id" {
  value = data.aws_route53_zone.zone.zone_id
}
