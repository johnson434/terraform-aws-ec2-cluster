# aws configure 없이 확인하려고 mock으로 확인
mock_provider "aws" {
  mock_resource "aws_subnet" {
    defaults = {
      id = "mock-subnet-id"
    }
  }
}

run "when_subnet_is_created_then_tag_name_equal_to_passing_name" {
  variables {
    name       = "subnet-name"
    vpc_id     = "mocking-vpc-id"
    cidr_block = "10.0.0.0/16"
    az         = "ap-northeast-2a"
  }

  assert {
    condition     = aws_subnet.default.tags["Name"] == var.name
    error_message = "subnet name tag not equal to passing name"
  }
}

run "when_subnet_is_created_then_cidr_block_is_equal_to_passing_cidr_block" {
  variables {
    name       = "subnet-name"
    vpc_id     = "mocking-vpc-id"
    cidr_block = "10.0.0.0/16"
    az         = "ap-northeast-2a"
  }

  assert {
    condition     = aws_subnet.default.cidr_block == var.cidr_block
    error_message = "subnet cidr_block not equal to passing cidr_block"
  }
}

run "when_subnet_is_created_then_output_id_is_equal_to_subnet_id" {
  variables {
    name       = "subnet-name"
    vpc_id     = "mocking-vpc-id"
    cidr_block = "10.0.0.0/16"
    az         = "ap-northeast-2a"
  }

  assert {
    condition     = aws_subnet.default.id == output.id
    error_message = "subnet is not equal to output id"
  }
}
