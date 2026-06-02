output "website_url" {
  value = "http://${aws_s3_bucket_website_configuration.site.website_endpoint}"
}

output "route53_name_servers" {
  value = aws_route53_zone.zone.name_servers
}
