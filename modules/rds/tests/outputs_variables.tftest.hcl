mock_provider "aws" {}

run "when_instance_created_then_id_is_equal_to_instance_id" {
  variables {
    project_name = "test"
    env = "dev"
    subnet_group_name = "test-subnet-group-name"
    allocated_storage = 5
    backup_retention_period = 3
    subnet_group_ids = ["subnet1", "subnet2"]
    db_name = "test-db-name"
    engine = "mysql" 
    engine_version = "engine_version"
    instance_class = "t3.medium"
    username = "test"
    using_default_password = true
    parameter_group_name = "parameter_group_name"
    skip_final_snapshot = true
  }

  assert {
    condition = output.id == aws_db_instance.default.id
    error_message = "output.id is not equal to aws_db_instance. output.id: ${output.id} aws_db_instance.default.id: ${aws_db_instance.default.id}"
  }
}

run "when_instance_created_then_address_is_equal_to_instance_address" {
  variables {
    project_name = "test"
    env = "dev"
    subnet_group_name = "test-subnet-group-name"
    allocated_storage = 5
    backup_retention_period = 3
    subnet_group_ids = ["subnet1", "subnet2"]
    db_name = "test-db-name"
    engine = "mysql" 
    engine_version = "engine_version"
    instance_class = "t3.medium"
    username = "test"
    using_default_password = true
    parameter_group_name = "parameter_group_name"
    skip_final_snapshot = true
  }

  assert {
    condition = output.address == aws_db_instance.default.address
    error_message = "output.address is not equal to aws_db_instance. output.address: ${output.address} aws_db_instance.default.address: ${aws_db_instance.default.address}"
  }
}

run "when_instance_created_then_arn_is_equal_to_instance_arn" {
  variables {
    project_name = "test"
    env = "dev"
    subnet_group_name = "test-subnet-group-name"
    allocated_storage = 5
    backup_retention_period = 3
    subnet_group_ids = ["subnet1", "subnet2"]
    db_name = "test-db-name"
    engine = "mysql" 
    engine_version = "engine_version"
    instance_class = "t3.medium"
    username = "test"
    using_default_password = true
    parameter_group_name = "parameter_group_name"
    skip_final_snapshot = true
  }

  assert {
    condition = output.arn == aws_db_instance.default.arn
    error_message = "output.arn is not equal to aws_db_instance. output.arn: ${output.arn} aws_db_instance.default.arn: ${aws_db_instance.default.arn}"
  }
}

run "when_instance_created_then_endpoint_is_equal_to_instance_endpoint" {
  variables {
    project_name = "test"
    env = "dev"
    subnet_group_name = "test-subnet-group-name"
    allocated_storage = 5
    backup_retention_period = 3
    subnet_group_ids = ["subnet1", "subnet2"]
    db_name = "test-db-name"
    engine = "mysql" 
    engine_version = "engine_version"
    instance_class = "t3.medium"
    username = "test"
    using_default_password = true
    parameter_group_name = "parameter_group_name"
    skip_final_snapshot = true
  }

  assert {
    condition = output.endpoint == aws_db_instance.default.endpoint
    error_message = "output.endpoint is not equal to aws_db_instance. output.endpoint: ${output.endpoint} aws_db_instance.default.endpoint: ${aws_db_instance.default.endpoint}"
  }
}
