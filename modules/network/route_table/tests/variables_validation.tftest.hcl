mock_provider "aws" {}

run "when_route_table_created_flag_is_true_and_route_table_id_is_passed_then_create_route_table_will_throw_error" {
  command = plan

  variables {
    create_route_table = true
    route_table_id     = "route-table-id"
    route_table_name   = "route_table_name"
    vpc_id             = "test-vpc-id"
    associated_subnet_ids = [
      "subnetid-1",
      "subnetid-2"
    ]
  }

  expect_failures = [
    var.create_route_table
  ]
}
