data "aws_ssm_parameter" "default_password" {
  count = var.using_default_password ? 1 : 0
  name  = "default_password"
}

resource "aws_db_subnet_group" "default" {
  subnet_ids = var.subnet_group_ids
  name       = "${var.project_name}-${var.env}-subnet-group-${var.subnet_group_name}"
}

resource "aws_db_instance" "default" {
  allocated_storage       = var.allocated_storage
  backup_retention_period = var.backup_retention_period
  db_subnet_group_name    = aws_db_subnet_group.default.name
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  multi_az                = var.multiaz
  username                = var.username
  password                = var.using_default_password ? data.aws_ssm_parameter.default_password[0].value : var.password
  storage_encrypted       = var.is_storage_encrypted

  timeouts {
    create = "3h"
    delete = "3h"
    update = "3h"
  }
}
