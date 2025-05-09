mock_provider "aws" {}

run "when_allocated_storage_is_zero_then_validation_throws_error" {
  command = plan

  variables {
    project_name = "test"
    env = "dev"
    subnet_group_name = "test-subnet-group-name"
    allocated_storage = 0
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

  expect_failures = [var.allocated_storage]
}

run "when_using_default_password_is_true_and_password_is_not_null_then_validation_throws_error" {
  command = plan

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
    password = "testpassword1234"
    parameter_group_name = "parameter_group_name"
    skip_final_snapshot = true
  }

  expect_failures = [var.using_default_password]
}

run "when_using_custom_password_and_and_password_is_null_then_validation_throws_error" {
  command = plan

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
    using_default_password = false
    password = null
    parameter_group_name = "parameter_group_name"
    skip_final_snapshot = true
  }

  expect_failures = [var.using_default_password]
}
