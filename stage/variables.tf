variable "project_name" {
  type        = string
  description = "리소스가 지원하는 서비스 이름"
}

variable "env" {
  type        = string
  description = "현재 "
  default     = "stage"

  validation {
    condition = anytrue([
      var.env == "dev", var.env == "prod", var.env == "stage"
    ])
    error_message = "환경은 dev, prod, stage 중 하나로 입력해주세요."
  }
}

variable "main_vpc_cidr_block" {
  type = string

  description = "main_vpc에서 사용할 cidr_block"
}

variable "subnets" {
  type = map(object({
    az = string
  }))

  description = "사용할 서브넷 집합. key가 subnet의 이름"
}

variable "web_nacl" {
  type = object({
    nacl_rules_ingress = list(object({
      rule_number = number
      protocol    = string
      rule_action = string
      cidr_block  = string
      from_port   = number
      to_port     = number
    }))
    nacl_rules_egress = list(object({
      rule_number = number
      protocol    = string
      rule_action = string
      cidr_block  = string
      from_port   = number
      to_port     = number
    }))
  })
}

variable "route_table_private" {
  type = object({
    name        = string
    vpc_name    = string
    subnet_name = string
  })
}

variable "route_table_rule_private" {
  type = list(object({
    destination_cidr_block = string
    gateway = object({
      type = string
      name = string
    })
  }))
}
