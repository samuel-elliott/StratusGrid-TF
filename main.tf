resource "aws_s3_bucket" "origin" {  
  bucket = var.s3_artifact_bucket
  acl    = "public-read"

  website {
    index_document = "index.html"    
    error_document = "error.html"   
 
  }

  tags = {
    Environment = var.environment
    }
}

resource "aws_s3_bucket_policy" "origin" {  
  bucket = aws_s3_bucket.origin.id

  policy = <<POLICY
{    
    "Version": "2012-10-17",    
    "Statement": [        
      {            
          "Sid": "PublicReadGetObject",            
          "Effect": "Allow",            
          "Principal": "*",            
          "Action": [                
             "s3:GetObject"            
          ],            
          "Resource": [
             "arn:aws:s3:::${aws_s3_bucket.origin.id}/*"            
          ]        
      }    
    ]
}
POLICY
}

resource "aws_kms_key" "s3_bucket_cmk_key" {
  description             = "S3 Artifact Bucket Key"
  deletion_window_in_days = 30
  enable_key_rotation = true
  key_usage = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
}
