resource "aws_ec2_managed_prefix_list" "test" {
  count          = var.create_prefix_list == true ? 1 : 0
  name           = var.name
  address_family = var.address_family
  max_entries    = var.max_entries

  tags = {
    Name = var.name
  }
}

resource "aws_ec2_managed_prefix_list_entry" "entry_1" {
  count          = length(var.entries)
  cidr           = var.entries[count.index].cidr
  description    = var.entries[count.index].description
  prefix_list_id = var.create_prefix_list == true ? aws_ec2_managed_prefix_list.test[0].id : var.prefix_id
}
