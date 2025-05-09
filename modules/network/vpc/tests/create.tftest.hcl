# aws configure 없이 확인하려고 mock으로 확인
mock_provider "aws" {
  mock_resource "aws_vpc" {
    defaults = {
      id = "mock-output-id"
    }
  }
}

run "when_vpc_created_then_tag_name_is_equal_to_passing_name" {
  command = plan

  variables {
    vpc_name       = "test_vpc_name"
    vpc_cidr_block = "10.0.0.0/16"
  }

  assert {
    condition     = aws_vpc.total_service.tags["Name"] == var.vpc_name
    error_message = "tag of vpc is not equal to passing vpc_name param."
  }
}

run "when_vpc_created_then_vpc_has_a_output_id" {
  command = apply

  variables {
    vpc_name       = "test_vpc_name"
    vpc_cidr_block = "10.0.0.0/16"
  }

  assert {
    condition     = output.id == aws_vpc.total_service.id
    error_message = "output is not equal to resource output id"
  }
}

run "when_vpc_created_then_vpc_has_a_output_name" {
  command = apply

  variables {
    vpc_name       = "test_vpc_name"
    vpc_cidr_block = "10.0.0.0/16"
  }

  assert {
    condition     = output.name == aws_vpc.total_service.tags["Name"]
    error_message = "output.name is not equal to resource name"
  }
}
