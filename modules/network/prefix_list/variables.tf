variable "create_prefix_list" {
  type        = bool
  default     = true
  description = "prefix_list를 만들지 여부. 만들지 않으면 prefix_list id를 입력 받고 해당 prefix_list에 entry를 추가한다."
}

variable "name" {
  type        = string
  description = "prefix_list의 이름"
}

variable "address_family" {
  type        = string
  description = "prefix_list가 사용할 address_family"

  validation {
    condition     = anytrue([var.address_family == "IPv4", var.address_family == "IPv6"])
    error_message = "prefix_list의 address_family는 IPv4 혹은 IPv6만 가능합니다."
  }
}

variable "max_entries" {
  type        = number
  description = "prefix_list에 들어갈 cidr block 최대 개수"
}

variable "prefix_id" {
  type     = string
  nullable = true

  validation {
    condition     = anytrue([alltrue([var.create_prefix_list == true, var.prefix_id == null]), alltrue([var.create_prefix_list != true, var.prefix_id != null])])
    error_message = "prefix_list를 만들"
  }
}

variable "entries" {
  type = list(object({
    cidr        = string
    description = string
    prefix_list = optional(string, null)
  }))
}
