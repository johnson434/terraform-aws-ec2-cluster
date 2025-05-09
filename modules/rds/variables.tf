variable "project_name" {
  type        = string
  description = "project_name"
}

variable "env" {
  type        = string
  description = "배포 환경. 예: dev, prod, stage"
  validation {
    condition     = anytrue([var.env == "dev", var.env == "prod", var.env == "stage"])
    error_message = "env값은 dev, prod, stage 중 하나입니다. 현재 var.env: ${var.env}"
  }
}

variable "subnet_group_name" {
  type        = string
  description = "RDS가 속할 서브넷 그룹의 이름"
}

variable "allocated_storage" {
  type        = number
  description = "DB Storage 용량"
  default     = 10

  validation {
    condition     = var.allocated_storage > 0
    error_message = "allocated_storage는 0보다 커야합니다."
  }
}

variable "backup_retention_period" {
  type        = number
  description = "백업 데이터 보유 기간"
  default     = 0
}

variable "subnet_group_ids" {
  type        = list(string)
  description = "DB가 속할 서브넷 그룹 IDS"
}


variable "multiaz" {
  type        = bool
  description = "DR로 MultiAZ 설정 여부"
  default     = false
}

variable "is_storage_encrypted" {
  type        = bool
  description = "Storage 암호화 여부"
  default     = true
}

variable "db_name" {
  type        = string
  description = "value"
}

variable "engine" {
  type        = string
  description = "데이터베이스 엔진"
}

variable "engine_version" {
  type        = string
  description = "엔진 버전"
}

variable "instance_class" {
  type        = string
  description = "Database 인스턴스가 사용할 instance_type"
}

variable "username" {
  type        = string
  description = "유저명"
  sensitive   = true
}

variable "using_default_password" {
  type        = bool
  description = "디폴트 비밀번호를 사용할지 여부"

  validation {
    condition     = anytrue([alltrue([var.password == null, var.using_default_password]), alltrue([var.password != null, !var.using_default_password])])
    error_message = "기본 비밀번호를 설정하려면 password를 null로 설정하고 기본 비밀번호를 설정하지 않는다면 password를 입력하세요."
  }
}

variable "password" {
  type        = string
  description = "유저 비밀번호로 null이라면 SSM Parameter의 default_password를 사용한다."
  nullable    = true
  sensitive   = true

  default = null
}

variable "parameter_group_name" {
  type        = string
  description = "parameter_group_name"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "RDS를 제거하기 전에 스냅샷을 찍을 지 여부. dev 환경에선 false"
  default     = false
}
