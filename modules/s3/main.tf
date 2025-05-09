resource "aws_s3_bucket" "user_data" {
  bucket = var.bucket_name

  provisioner "local-exec" {
    when = destroy
    environment = {
      bucket_name = self.bucket
    }
    command = "${path.module}/scripts/empty_bucket.sh $bucket_name"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.ap-northeast-2.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.route_table_ids
}
