mock_provider "aws" {}

run "when_nacl_created_flag_is_true_then_acl_is_created" {
  variables {
    create_nacl = true
    vpc_id      = "test-vpc-id"
    subnet_id   = "test-subnet-id"
  }

  assert {
    condition     = length(aws_network_acl.default) == 1
    error_message = "Nacl resource length is not 0"
  }
}

run "when_nacl_created_flag_is_false_then_acl_is_not_created" {
  variables {
    create_nacl = false
    nacl_id     = "test-nacl-id"
    vpc_id      = "test-vpc-id"
    subnet_id   = "test-subnet-id"
  }

  assert {
    condition     = length(aws_network_acl.default) == 0
    error_message = "create_nacl flag is false but nacl is created."
  }
}

run "when_nacl_created_flag_is_true_and_ingress_rules_egress_rules_are_passed_then_acl_is_created_and_rules_are_created" {
  variables {
    create_nacl = true
    vpc_id      = "test-vpc-id"
    subnet_id   = "subnet_id"
    nacl_rules_ingress = [
      {
        rule_number = 100
        protocol    = "tcp"
        rule_action = "allow"
        cidr_block  = "10.0.0.0/8"
        from_port   = 80
        to_port     = 80
      },
      {
        rule_number = 200
        protocol    = "tcp"
        rule_action = "allow"
        cidr_block  = "10.0.0.0/8"
        from_port   = 22
        to_port     = 22
      }
    ]
    nacl_rules_egress = [
      {
        rule_number = 100
        protocol    = "tcp"
        rule_action = "allow"
        cidr_block  = "10.0.0.0/8"
        from_port   = 30000
        to_port     = 65535
      },
      {
        rule_number = 200
        protocol    = "tcp"
        rule_action = "allow"
        cidr_block  = "10.0.0.0/8"
        from_port   = 80
        to_port     = 80
      },
      {
        rule_number = 300
        protocol    = "tcp"
        rule_action = "allow"
        cidr_block  = "10.0.0.0/8"
        from_port   = 443
        to_port     = 443
      }
    ]
  }

  assert {
    condition     = alltrue([length(aws_network_acl.default) == 1, length(aws_network_acl_rule.ingress) == 2, length(aws_network_acl_rule.egress) == 3])
    error_message = "aws_network_acl.length = ${length(aws_network_acl.default)} aws_network_acl_rule.ingress = ${length(aws_network_acl_rule.ingress)} aws_network_acl_rule.egress = ${length(aws_network_acl_rule.egress)}"
  }
}
