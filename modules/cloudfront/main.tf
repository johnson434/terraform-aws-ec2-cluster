data "aws_caller_identity" "current" {}

locals {
  account_id   = data.aws_caller_identity.current.account_id
  s3_origin_id = "front_web_page"
}

resource "aws_s3_bucket" "origin" {
  bucket = var.bucket_name

  provisioner "local-exec" {
    when    = create
    command = "${path.module}/shell/put_default_index_html.sh true ${aws_s3_bucket.origin.bucket} ${path.module}/res/index.html"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "${path.module}/shell/empty_bucket.sh ${self.bucket}"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.origin.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket_owner_preffered" {
  bucket = aws_s3_bucket.origin.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "private" {
  bucket = aws_s3_bucket.origin.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "private" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket_owner_preffered]
  bucket     = aws_s3_bucket.origin.id
  acl        = "private"
}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.origin.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadOnly"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      aws_s3_bucket.origin.arn,
      "${aws_s3_bucket.origin.arn}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values = [
        aws_cloudfront_distribution.s3_distribution.arn
      ]
    }
  }
}

resource "aws_cloudfront_origin_access_control" "s3_origin_access" {
  name                              = "S3AccessOriginControl"
  description                       = "S3 bucket as a origin"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.origin.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_origin_access.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  #  ordered_cache_behavior {
  #    path_pattern     = "/*"
  #    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
  #    cached_methods   = ["GET", "HEAD", "OPTIONS"]
  #    target_origin_id = local.s3_origin_id
  #
  #    forwarded_values {
  #      query_string = false
  #      headers      = ["Origin"]
  #
  #      cookies {
  #        forward = "none"
  #      }
  #    }
  #
  #    min_ttl                = 0
  #    default_ttl            = 86400
  #    max_ttl                = 31536000
  #    compress               = true
  #    viewer_protocol_policy = "redirect-to-https"
  #  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["KR"]
    }
  }

  #  tags = {
  #    
  #    Environment = "production"
  #  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
