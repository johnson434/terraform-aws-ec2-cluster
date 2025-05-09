resource "aws_subnet" "default" {
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_block
  availability_zone = var.az

  tags = {
    Name = var.name
  }
}
