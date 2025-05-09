mock_provider "aws" {}

run "when_route_table_created_flag_is_true_then_route_table_is_created" {
  variables {
    create_route_table = true
    route_table_name   = "route_table_name"
    vpc_id             = "test-vpc-id"
    associated_subnet_ids = [
      "subnetid-1",
      "subnetid-2"
    ]
  }

  assert {
    condition     = length(aws_route_table.default) == 1
    error_message = "Nacl resource length is not 0"
  }
}

run "when_route_table_created_flag_is_false_then_route_table_is_not_created" {
  variables {
    create_route_table = false
    route_table_id     = "route-table-id"
    route_table_name   = "route_table_name"
    vpc_id             = "test-vpc-id"
    associated_subnet_ids = [
      "subnetid-1",
      "subnetid-2"
    ]
  }

  assert {
    condition     = length(aws_route_table.default) == 0
    error_message = "create_nacl flag is false but nacl is created."
  }
}

run "when_route_table_created_is_true_and_routes_is_passed_then_route_table_is_created_and_rules_are_created" {
  variables {
    create_route_table = true
    route_table_name   = "route_table_name"
    vpc_id             = "test-vpc-id"
    associated_subnet_ids = [
      "subnetid-1",
      "subnetid-2"
    ]
    aws_routes = [
      {
        destination_cidr_block = "0.0.0.0/0"
        gateway_id             = "igw"
      },
      {
        destination_cidr_block = "0.0.0.0/0"
        gateway_id             = "nat-123123"
      }
    ]
  }

  assert {
    condition     = alltrue([length(aws_route_table.default) == 1, length(aws_route.default) == 2])
    error_message = "aws_route_table.default.length = ${length(aws_route_table.default)} aws_routes.default.length = ${length(aws_route.default)}"
  }
}
