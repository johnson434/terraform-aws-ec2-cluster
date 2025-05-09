mock_provider "aws" {
  mock_resource "aws_security_group" {
    defaults = {
      id = "mock-resource-id"
    }
  }
}

run "when_ingress_cidripv6_sg_rule_created_without_sg_then_output_id_is_equal_tolocal_sg_id" {
  variables {
    create_sg         = false
    security_group_id = "test-sg-id"
    vpc_id            = "vpc-id"
    name              = "test-sg"
    description       = "web sg"
    ingress_rules_cidr_ipv6 = [
      {
        cidr_ipv6   = "0000:0000:0000:0000:0000:0000:0000:0000/16"
        ip_protocol = "tcp"
        from_port   = 80
        to_port     = 80
      }
    ]
  }

  assert {
    condition     = local.security_group_id == output.id
    error_message = "local.security_group_id is not equal to output.id"
  }
}

run "when_create_sg_is_false_then_aws_security_group_is_not_created" {
  variables {
    create_sg         = false
    security_group_id = "mocking-sg-id"

    vpc_id      = "vpc-id"
    name        = "test-sg"
    description = "web sg"
  }

  assert {
    condition     = length(aws_security_group.default) == 0
    error_message = "Security Group is created."
  }
}

run "when_ingress_ref_sg_rule_created_without_sg_then_ingress_resource_length_is_1" {
  variables {
    create_sg         = false
    security_group_id = "test-sg-id"
    vpc_id            = "vpc-id"
    name              = "test-sg"
    description       = "web sg"
    ingress_rules_referenced_sg = [
      {
        referenced_sg_id = "referenced_sg_id"
        ip_protocol      = "tcp"
        from_port        = 80
        to_port          = 80
      }
    ]
  }

  assert {
    condition     = length(aws_vpc_security_group_ingress_rule.referenced_sg) == 1
    error_message = "Ingress rule length is not 0."
  }
}

run "when_ingress_cidripv4_sg_rule_created_without_sg_then_ingress_resource_length_is_1" {
  variables {
    create_sg         = false
    security_group_id = "test-sg-id"
    vpc_id            = "vpc-id"
    name              = "test-sg"
    description       = "web sg"
    ingress_rules_cidr_ipv4 = [
      {
        cidr_ipv4   = "10.0.0.0/16"
        ip_protocol = "tcp"
        from_port   = 80
        to_port     = 80
      }
    ]
  }

  assert {
    condition     = length(aws_vpc_security_group_ingress_rule.cidr_ipv4) == 1
    error_message = "Ingress rule length is not 0."
  }
}

run "when_ingress_cidripv6_sg_rule_created_without_sg_then_ingress_resource_length_is_1" {
  variables {
    create_sg         = false
    security_group_id = "test-sg-id"
    vpc_id            = "vpc-id"
    name              = "test-sg"
    description       = "web sg"
    ingress_rules_cidr_ipv6 = [
      {
        cidr_ipv6   = "0000:0000:0000:0000:0000:0000:0000:0000/16"
        ip_protocol = "tcp"
        from_port   = 80
        to_port     = 80
      }
    ]
  }

  assert {
    condition     = length(aws_vpc_security_group_ingress_rule.cidr_ipv6) == 1
    error_message = "Ingress rule length is not 0."
  }
}
