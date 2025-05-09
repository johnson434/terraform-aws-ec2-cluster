# aws configure 없이 확인하려고 mock으로 확인
mock_provider "aws" {
  mock_resource "aws_security_group" {
    defaults = {
      id = "mock-resource-id"
    }
  }
}

run "when_sg_created_then_name_equal_to_passing_name" {
  variables {
    create_sg   = true
    vpc_id      = "vpc-id"
    name        = "test-sg"
    description = "web sg"
  }

  assert {
    condition     = aws_security_group.default[0].name == var.name
    error_message = "security_group is not blahblah name: ${aws_security_group.default[0].name}"
  }
}

run "when_sg_created_then_tag_name_equal_to_passing_tag_name" {
  variables {
    create_sg   = true
    vpc_id      = "vpc-id"
    name        = "test-sg"
    description = "web sg"
  }

  assert {
    condition     = aws_security_group.default[0].name == aws_security_group.default[0].tags["Name"]
    error_message = "security_group name and tag name aren't equal. ${aws_security_group.default[0].name} ${aws_security_group.default[0].tags["Name"]}"
  }
}

run "when_sg_created_then_output_id_equal_to_resource_id" {
  variables {
    create_sg   = true
    vpc_id      = "vpc-id"
    name        = "test-sg"
    description = "web sg"
  }

  assert {
    condition     = aws_security_group.default[0].id == output.id
    error_message = "security_group name and tag name aren't equal. ${aws_security_group.default[0].name} ${aws_security_group.default[0].tags["Name"]}"
  }
}
