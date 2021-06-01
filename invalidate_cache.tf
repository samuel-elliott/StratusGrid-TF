# Lambda defined here invalidates CloudFront cache in case the cached object
# in S3 is changed
resource "aws_iam_role" "invalidate_cloud_front_role" {
  name  = "invalidate_cloud_front"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "invalidate_cloud_front_policy" {
  name        = "invalidate_cloud_front_policy"
  description = "Allow to create CloudFront invalidations"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudfront:CreateInvalidation"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "invalidate_cloud_front_attachment" {
  role       = aws_iam_role.invalidate_cloud_front_role.name
  policy_arn = aws_iam_policy.invalidate_cloud_front_policy.arn
}

data "archive_file" "invalidate_cloud_front_lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/invalidate_cloud_front.py"
  output_path = "${path.module}/invalidate_cloud_front_lambda.zip"
}

resource "aws_lambda_function" "invalidate_cloud_front_lambda" {
  filename         = data.archive_file.invalidate_cloud_front_lambda_zip.output_path
  function_name    = "invalidate_cloud_front_on_s3_change"
  role             = aws_iam_role.invalidate_cloud_front_role.arn
  handler          = "invalidate_cloud_front.handle_s3_change"
  source_code_hash = data.archive_file.invalidate_cloud_front_lambda_zip.output_base64sha256
  runtime          = "python3.7"

  environment {
    variables = {
      CLOUDFRONT_DISTRIBUTION_ID = try(aws_cloudfront_distribution.s3_distribution.id, "")
    }
  }
}

resource "aws_lambda_permission" "allow_s3_event_notifications" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.invalidate_cloud_front_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.origin.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.origin.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.invalidate_cloud_front_lambda.arn
    events              = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]
  }
}
