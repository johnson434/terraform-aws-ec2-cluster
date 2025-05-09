variable "name" {
  type        = string
  description = "Subnet 이름"
}

variable "vpc_id" {
  type        = string
  description = "Subnet이 속할 VPC의 ID"
}

variable "cidr_block" {
  type        = string
  description = "Subnet의 CIDR Block"
}

variable "az" {
  type        = string
  description = "Subnet이 배치될 Availability Zone"
}
