output "s3_bucket_id" {
  value = aws_s3_bucket.origin.id
}

output "s3_bucket_domain_name" {    
  value = aws_s3_bucket.origin.bucket_domain_name
}

output "cf_domain_name" {
  value       = try(aws_cloudfront_distribution.s3_distribution.domain_name, "")
}
