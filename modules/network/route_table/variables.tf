variable "create_route_table" {
  type        = bool
  description = "라우트 테이블을 생성할지 여부"

  validation {
    condition = anytrue([
      alltrue([
        var.create_route_table,
        var.route_table_id == null
      ]),
      alltrue([
        !var.create_route_table,
        var.route_table_id != null
      ])
    ])
    error_message = "route_table을 생성하면 route_table_id가 필요없습니다. route_table을 생성하지 않는다면 route_table_rule과 조합할 route_table_id를 입력하세요."
  }
}

variable "route_table_id" {
  type        = string
  description = "라우트 테이블을 생성하지 않으면 해당 라우트 테이블에 규칙을 작성한다."

  nullable = true
  default  = null
}

variable "route_table_name" {
  type        = string
  description = "Route Table name"
}

variable "vpc_id" {
  type        = string
  description = "라우트테이블이 속할 VPC ID"
}

variable "associated_subnet_ids" {
  type        = list(string)
  description = "라우트 테이블이랑 협력하는 서브넷 아이디들"
}

variable "aws_routes" {
  type = list(object({
    destination_cidr_block = string
    gateway_id             = string
  }))
  description = "로컬 라우트 룰"

  nullable = true
  default  = null
}
