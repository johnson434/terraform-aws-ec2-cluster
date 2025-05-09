variable "bucket_name" {
  type        = string
  description = "cloudfront origin bucket의 이름"
  default     = "testtest123154215125124"
}

variable "versioning_enabled" {
  type        = bool
  description = "s3 versioning 활성화 여부"
  default     = false
}
variable "using_default_index_page" {
  type        = bool
  description = "기본 index.html 페이지를 업로드합니다."
  default     = false
}

variable "price_class" {
  type        = string
  description = "Cloudfront가 사용할 요금제."
  default     = "PriceClass_100"

  validation {
    condition     = anytrue([var.price_class == "PriceClass_All", var.price_class == "PriceClass_100", var.price_class == "PriceClass_200"])
    error_message = "price_class는 [PriceClass_All, PriceClass_100, PriceClass_200] 중에 하나만 가능합니다. 현재 price_class: ${var.price_class}"
  }
}
