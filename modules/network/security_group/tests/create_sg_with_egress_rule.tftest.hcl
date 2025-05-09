# aws configure 없이 확인하려고 mock으로 확인
mock_provider "aws" {
  mock_resource "aws_security_group" {
    defaults = {
      id = "mock-resource-id"
    }
  }
}

run "when_sg_and_egress_ref_sg_rule_created_then_egress_resource_length_is_1" {
  variables {
    create_sg   = true
    vpc_id      = "vpc-id"
    name        = "test-sg"
    description = "web sg"
    egress_rules_referenced_sg = [
      {
        referenced_sg_id = "referenced_sg_id"
        ip_protocol      = "tcp"
        from_port        = 80
        to_port          = 80
      }
    ]
  }

  assert {
    condition     = length(aws_vpc_security_group_egress_rule.referenced_sg) == 1
    error_message = "Ingress rule length is not 0."
  }
}

run "when_sg_and_egress_cidripv4_sg_rule_created_then_egress_resource_length_is_1" {
  variables {
    create_sg   = true
    vpc_id      = "vpc-id"
    name        = "test-sg"
    description = "web sg"
    egress_rules_cidr_ipv4 = [
      {
        cidr_ipv4   = "10.0.0.0/16"
        ip_protocol = "tcp"
        from_port   = 80
        to_port     = 80
      }
    ]
  }

  assert {
    condition     = length(aws_vpc_security_group_egress_rule.cidr_ipv4) == 1
    error_message = "Ingress rule length is not 0."
  }
}

run "when_sg_and_egress_cidripv6_sg_rule_created_then_egress_resource_length_is_1" {
  variables {
    create_sg   = true
    vpc_id      = "vpc-id"
    name        = "test-sg"
    description = "web sg"
    egress_rules_cidr_ipv6 = [
      {
        cidr_ipv6   = "0000:0000:0000:0000:0000:0000:0000:0000/16"
        ip_protocol = "tcp"
        from_port   = 80
        to_port     = 80
      }
    ]
  }

  assert {
    condition     = length(aws_vpc_security_group_egress_rule.cidr_ipv6) == 1
    error_message = "Ingress rule length is not 0."
  }
}
