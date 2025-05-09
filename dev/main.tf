module "main_vpc" {
  source = "../modules/network/vpc"

  vpc_name       = "${var.project_name}-${var.env}-vpc"
  vpc_cidr_block = var.main_vpc_cidr_block
}

locals {
  web_subnet = cidrsubnet(var.main_vpc_cidr_block, 8, length(var.subnets) + 1)
}

module "subnets" {
  count  = length(keys(var.subnets))
  source = "../modules/network/subnet"

  name = join(
    "-",
    [
      var.project_name,
      var.env,
      "subnet",
      element(keys(var.subnets), count.index)
    ]
  )

  vpc_id     = module.main_vpc.id
  cidr_block = cidrsubnet(var.main_vpc_cidr_block, 8, count.index)
  az         = element(values(var.subnets), count.index).az
}

module "igw_route_table" {
  source = "../modules/network/route_table"

  create_route_table    = true
  route_table_name      = "IGWRouteTable"
  vpc_id                = module.main_vpc.id
  associated_subnet_ids = module.subnets[*].id
  aws_routes = [
    {
      destination_cidr_block = "0.0.0.0/0"
      gateway_id             = module.igw.id
    }
  ]
}

module "web_nacl" {
  source = "../modules/network/nacl"

  create_nacl        = true
  vpc_id             = module.main_vpc.id
  subnet_id          = module.subnets[0].id
  nacl_rules_ingress = var.web_nacl.nacl_rules_ingress
  nacl_rules_egress  = var.web_nacl.nacl_rules_egress
}

module "igw" {
  source = "../modules/network/igw"

  name   = join("-", [var.project_name, var.env, "igw"])
  vpc_id = module.main_vpc.id
}

module "alb_security_group" {
  source      = "../modules/network/security_group"
  create_sg   = true
  vpc_id      = module.main_vpc.id
  name        = "ALB"
  description = "alb sg"

  ingress_rules_cidr_ipv4 = [{
    cidr_ipv4   = "0.0.0.0/0"
    ip_protocol = "tcp"
    from_port   = 443
    to_port     = 443
  }]
}

module "cloudfront_front_page" {
  source                   = "../modules/cloudfront"
  bucket_name              = "web-front-bucket-test"
  using_default_index_page = true
}
