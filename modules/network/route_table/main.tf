locals {
  route_table_id = var.create_route_table ? one(aws_route_table.default).id : var.route_table_id
}

resource "aws_route_table" "default" {
  count  = var.create_route_table ? 1 : 0
  vpc_id = var.vpc_id

  tags = {
    Name = var.route_table_name
  }
}

resource "aws_route_table_association" "default" {
  count          = length(var.associated_subnet_ids)
  subnet_id      = var.associated_subnet_ids[count.index]
  route_table_id = local.route_table_id
}

resource "aws_route" "default" {
  count                  = var.aws_routes != null ? length(var.aws_routes) : 0
  route_table_id         = local.route_table_id
  destination_cidr_block = var.aws_routes[count.index].destination_cidr_block
  gateway_id             = var.aws_routes[count.index].gateway_id
}
