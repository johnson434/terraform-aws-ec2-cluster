variable "vpc_id" {
  type        = string
  description = "vpc_endpoint vpc id"
}

variable "bucket_name" {
  type        = string
  description = "bucket name"
}

variable "route_table_ids" {
  type        = list(string)
  description = "endpoint와 연결될 route_table들"
  default     = []
}
