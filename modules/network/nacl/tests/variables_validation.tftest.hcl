mock_provider "aws" {}

run "when_nacl_created_flag_is_true_and_nacl_id_is_passed_then_create_nacl_will_throw_error" {
  command = plan

  variables {
    create_nacl = true
    nacl_id     = "test-nacl-id"
    vpc_id      = "test-vpc-id"
    subnet_id   = "test-subnet-id"
  }

  expect_failures = [
    var.create_nacl
  ]
}
