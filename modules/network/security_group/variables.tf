variable "create_sg" {
  type        = bool
  description = "bool to decide neither create sg. if true then create sg or search the sg and using that sg to attach security_group_rule."
  default     = true

  validation {
    condition     = anytrue([alltrue([var.create_sg, var.security_group_id == null]), alltrue([!var.create_sg, var.security_group_id != null])])
    error_message = "보안그룹을 만들면 security_group_id를 null로, 만들지 않는다면 해당 보안규칙을 추가할 security_group_id가 필요합니다."
  }
}

variable "security_group_id" {
  type        = string
  description = "보안그룹을 만들지 않고, 규칙만 추가한다면 해당 규칙을 추가할 보안그룹의 ID"
  default     = null
  nullable    = true
}

variable "vpc_id" {
  type        = string
  description = "The VPC id to which security group belongs."
}

variable "name" {
  type        = string
  description = "security group name"
}

variable "description" {
  type        = string
  description = "security group description"
}

variable "ingress_rules_referenced_sg" {
  type = list(object({
    referenced_sg_id = optional(string)
    ip_protocol      = optional(string)
    from_port        = number
    to_port          = number
  }))

  nullable = true
  default  = null
}

variable "ingress_rules_cidr_ipv4" {
  type = list(object({
    cidr_ipv4   = optional(string)
    ip_protocol = optional(string)
    from_port   = number
    to_port     = number
  }))

  nullable = true
  default  = null
}

variable "ingress_rules_cidr_ipv6" {
  type = list(object({
    cidr_ipv6   = optional(string)
    ip_protocol = optional(string)
    from_port   = number
    to_port     = number
  }))

  nullable = true
  default  = null
}

variable "egress_rules_referenced_sg" {
  type = list(object({
    referenced_sg_id = optional(string)
    ip_protocol      = optional(string)
    from_port        = number
    to_port          = number
  }))

  nullable = true
  default  = null
}

variable "egress_rules_cidr_ipv4" {
  type = list(object({
    cidr_ipv4   = optional(string)
    ip_protocol = optional(string)
    from_port   = number
    to_port     = number
  }))

  nullable = true
  default  = null
}

variable "egress_rules_cidr_ipv6" {
  type = list(object({
    cidr_ipv6   = optional(string)
    ip_protocol = optional(string)
    from_port   = number
    to_port     = number
  }))

  nullable = true
  default  = null
}
