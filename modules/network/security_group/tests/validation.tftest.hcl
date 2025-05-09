mock_provider "aws" {}

run "when_create_sg_flag_is_true_and_sg_id_is_given_than_create_sg_will_throw_error" {
  command = plan

  variables {
    create_sg         = true
    security_group_id = "test-sg-id"
    vpc_id            = "vpc-id"
    name              = "test-sg"
    description       = "web sg"
  }

  expect_failures = [
    var.create_sg
  ]
}
