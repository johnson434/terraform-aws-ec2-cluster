variable "project_name" {
  type        = string
  description = "리소스가 지원하는 서비스 이름"
}

variable "env" {
  type        = string
  description = "현재 "
  default     = "dev"

  validation {
    condition = anytrue([
      var.env == "dev", var.env == "prod", var.env == "stage"
    ])
    error_message = "환경은 dev, prod, stage 중 하나로 입력해주세요."
  }
}
