resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.origin.bucket_regional_domain_name
    origin_id   = var.s3_origin_id
  }
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Sam Elliott's CloudFront cached S3 static project."
  default_root_object = "index.html"
  
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_origin_id


  forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  
    min_ttl					= 0
    default_ttl				= 0
    max_ttl					= 0
    compress				= true
	viewer_protocol_policy	= "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern     = "/images/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = var.s3_origin_id
  
  forwarded_values {
      query_string = false
      headers      = ["Origin"]
 
      cookies {
        forward = "none"
      }
    }
    min_ttl                = 1800
    default_ttl            = 1800
    max_ttl                = 1800
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }
  
  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }
  tags = {
    Environment = var.environment
    }
  
  viewer_certificate {
    cloudfront_default_certificate = true
  }

}
