locals {
  nacl_id = var.create_nacl ? one(aws_network_acl.default).id : var.nacl_id
}

resource "aws_network_acl" "default" {
  count  = var.create_nacl ? 1 : 0
  vpc_id = var.vpc_id
}

resource "aws_network_acl_association" "default" {
  count          = var.create_nacl ? 1 : 0
  network_acl_id = local.nacl_id
  subnet_id      = var.subnet_id
}

resource "aws_network_acl_rule" "ingress" {
  count = var.nacl_rules_ingress != null ? length(var.nacl_rules_ingress) : 0

  network_acl_id = local.nacl_id
  rule_number    = var.nacl_rules_ingress[count.index].rule_number
  egress         = false
  protocol       = var.nacl_rules_ingress[count.index].protocol
  rule_action    = var.nacl_rules_ingress[count.index].rule_action
  cidr_block     = var.nacl_rules_ingress[count.index].cidr_block
  from_port      = var.nacl_rules_ingress[count.index].from_port
  to_port        = var.nacl_rules_ingress[count.index].to_port
}

resource "aws_network_acl_rule" "egress" {
  count = var.nacl_rules_egress != null ? length(var.nacl_rules_egress) : 0

  network_acl_id = local.nacl_id
  rule_number    = var.nacl_rules_egress[count.index].rule_number
  egress         = true
  protocol       = var.nacl_rules_egress[count.index].protocol
  rule_action    = var.nacl_rules_egress[count.index].rule_action
  cidr_block     = var.nacl_rules_egress[count.index].cidr_block
  from_port      = var.nacl_rules_egress[count.index].from_port
  to_port        = var.nacl_rules_egress[count.index].to_port
}
