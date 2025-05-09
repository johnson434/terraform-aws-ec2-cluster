variable "create_nacl" {
  type        = bool
  description = "acl 생성 여부"

  validation {
    condition     = anytrue([alltrue([var.create_nacl, var.nacl_id == null]), alltrue([!var.create_nacl, var.nacl_id != null])])
    error_message = "create_acl을 통해 acl을 생성하는 경우엔 acl_id를 사용하지 않습니다. acl_id는 acl을 만들지 않고 외부에서 의존받을 경우에만 입력 받습니다."
  }
}

variable "nacl_id" {
  type        = string
  description = "NACL을 만들지 않고, 기존 ACL을 사용할 경우에 입력"
  default     = null

  nullable = true
}

variable "vpc_id" {
  type        = string
  description = "NACL이 속할 VPC"
}

variable "subnet_id" {
  type        = string
  description = "NACL이 적용될 서브넷"
}

variable "nacl_rules_ingress" {
  type = list(object({
    rule_number = number
    protocol    = string
    rule_action = string
    cidr_block  = string
    from_port   = number
    to_port     = number
  }))
  default = null

  nullable = true
}

variable "nacl_rules_egress" {
  type = list(object({
    rule_number = number
    protocol    = string
    rule_action = string
    cidr_block  = string
    from_port   = number
    to_port     = number
  }))
  default = null

  nullable = true
}
