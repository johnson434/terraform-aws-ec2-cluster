locals {
  main_vpc_cidr_block = "171.32.0.0/16"
  nat_cidr            = cidrsubnet(local.main_vpc_cidr_block, 8, 1)
  alb_a_cidr          = cidrsubnet(local.main_vpc_cidr_block, 8, 2)
  alb_b_cidr          = cidrsubnet(local.main_vpc_cidr_block, 8, 3)
  control_plane_cidr  = cidrsubnet(local.main_vpc_cidr_block, 8, 4)
  worker_cidr         = cidrsubnet(local.main_vpc_cidr_block, 8, 6)
  rdbms_a_cidr        = cidrsubnet(local.main_vpc_cidr_block, 8, 10)
  rdbms_b_cidr        = cidrsubnet(local.main_vpc_cidr_block, 8, 11)
  rdbms_subnets = {
    "${var.project_name}-${var.env}-rdbms-a" : {
      cidr_block = local.rdbms_a_cidr
      az         = "ap-northeast-2a"
    },
    "${var.project_name}-${var.env}-rdbms-b" : {
      cidr_block = local.rdbms_b_cidr
      az         = "ap-northeast-2b"
    }
  }
}

module "main_vpc" {
  source = "../modules/network/vpc"

  vpc_name       = "${var.project_name}-${var.env}-vpc"
  vpc_cidr_block = local.main_vpc_cidr_block
}

module "igw" {
  source = "../modules/network/igw"

  name   = join("-", [var.project_name, var.env, "igw"])
  vpc_id = module.main_vpc.id
}

module "nat" {
  source = "../modules/network/nat"

  subnet_id = module.nat_subnet.id
}

module "main_vpc_pl" {
  source = "../modules/network/prefix_list"

  prefix_id          = null
  create_prefix_list = true
  address_family     = "IPv4"
  max_entries        = 1
  name               = "${var.project_name}-${var.env}-vpc"

  entries = [
    {
      cidr        = local.main_vpc_cidr_block
      description = "cidr block of main vpc"
    }
  ]
}

module "nat_prefix_list" {
  source = "../modules/network/prefix_list"

  prefix_id          = null
  create_prefix_list = true
  address_family     = "IPv4"
  max_entries        = 3
  name               = "${var.project_name}-${var.env}-nat"

  entries = [
    {
      cidr        = local.nat_cidr
      description = "nat prefix"
    }
  ]
}

module "alb_prefix_list" {
  source = "../modules/network/prefix_list"

  prefix_id          = null
  create_prefix_list = true
  address_family     = "IPv4"
  max_entries        = 4
  name               = "${var.project_name}-${var.env}-alb"

  entries = [
    {
      cidr        = local.alb_a_cidr
      description = "alb for avaliability zone a"
    },
    {
      cidr        = local.alb_b_cidr
      description = "alb for avaliability zone b"
    }
  ]
}

module "control_plane_prefix_list" {
  source = "../modules/network/prefix_list"

  prefix_id          = null
  create_prefix_list = true
  address_family     = "IPv4"
  max_entries        = 2
  name               = "${var.project_name}-${var.env}-cp"

  entries = [
    {
      cidr        = local.control_plane_cidr
      description = "control plane cidr blocks"
    }
  ]
}

module "worker_node_prefix_list" {
  source = "../modules/network/prefix_list"

  prefix_id          = null
  create_prefix_list = true
  address_family     = "IPv4"
  max_entries        = 4
  name               = "${var.project_name}-${var.env}-worker"

  entries = [
    {
      cidr        = local.worker_cidr
      description = "worker nodes cidr blocks"
    }
  ]
}

module "rdbms_prefix_list" {
  source = "../modules/network/prefix_list"

  prefix_id          = null
  create_prefix_list = true
  address_family     = "IPv4"
  max_entries        = 2
  name               = "${var.project_name}-${var.env}-rdbms"

  entries = [
    {
      cidr        = local.rdbms_a_cidr
      description = "rdbms az a cidr block"
    },
    {
      cidr        = local.rdbms_b_cidr
      description = "rdbms az b cidr block"
    }
  ]
}

module "igw_route_table" {
  source = "../modules/network/route_table"

  create_route_table    = true
  route_table_name      = "${var.project_name}-${var.env}-igw"
  vpc_id                = module.main_vpc.id
  associated_subnet_ids = [module.nat_subnet.id]
  aws_routes = [
    {
      destination_cidr_block = "0.0.0.0/0",
      gateway_id             = module.igw.id
    }
  ]
}

module "worker_node_route_table" {
  source = "../modules/network/route_table"

  create_route_table    = true
  route_table_name      = "${var.project_name}-${var.env}-worker"
  vpc_id                = module.main_vpc.id
  associated_subnet_ids = [module.worker_subnet.id]
  aws_routes = [
    {
      destination_cidr_block = "0.0.0.0/0",
      gateway_id             = module.nat.id
    }
  ]
}

module "local_route_table" {
  source = "../modules/network/route_table"

  create_route_table = true
  route_table_name   = "${var.project_name}-${var.env}-local"
  vpc_id             = module.main_vpc.id
  associated_subnet_ids = concat(
    [
      module.alb_a_subnet.id,
      module.alb_b_subnet.id,
      module.control_plane_subnet.id,
    ],
    [for key, v in module.rdbms_subnets : v.id]
  )
  aws_routes = []
}

module "worker_prefix_list" {
  source = "../modules/network/prefix_list"

  prefix_id          = null
  create_prefix_list = true
  address_family     = "IPv4"
  max_entries        = 3
  name               = "${var.project_name}-${var.env}-worker"

  entries = [
    {
      cidr        = local.worker_cidr
      description = "worker_cidr"
    }
  ]
}

module "nat_subnet" {
  source = "../modules/network/subnet"

  name       = "${var.project_name}-${var.env}-nat"
  vpc_id     = module.main_vpc.id
  cidr_block = local.nat_cidr
  az         = "ap-northeast-2a"
}

module "alb_a_subnet" {
  source = "../modules/network/subnet"

  name       = "${var.project_name}-${var.env}-alb-a"
  vpc_id     = module.main_vpc.id
  cidr_block = local.alb_a_cidr
  az         = "ap-northeast-2a"
}

module "alb_b_subnet" {
  source = "../modules/network/subnet"

  name       = "${var.project_name}-${var.env}-alb-b"
  vpc_id     = module.main_vpc.id
  cidr_block = local.alb_b_cidr
  az         = "ap-northeast-2b"
}

module "control_plane_subnet" {
  source = "../modules/network/subnet"

  name       = "${var.project_name}-${var.env}-cp"
  vpc_id     = module.main_vpc.id
  cidr_block = local.control_plane_cidr
  az         = "ap-northeast-2a"
}

module "worker_subnet" {
  source = "../modules/network/subnet"

  name       = "${var.project_name}-${var.env}-worker"
  vpc_id     = module.main_vpc.id
  cidr_block = local.worker_cidr
  az         = "ap-northeast-2a"
}

module "rdbms_subnets" {
  for_each = local.rdbms_subnets
  source   = "../modules/network/subnet"

  name       = each.key
  vpc_id     = module.main_vpc.id
  cidr_block = each.value.cidr_block
  az         = each.value.az
}

#module "nat_nacl" {
#  source = "../modules/network/nacl"
#
#  name        = "${var.project_name}-${var.env}-nat"
#  create_nacl = true
#  vpc_id      = module.main_vpc.id
#  subnet_id   = module.nat_subnet.id
#  nacl_rules_ingress = [
#    {
#      rule_number = 100
#      protocol    = "tcp"
#      rule_action = "allow"
#      cidr_block  = local.worker_cidr
#      from_port   = 80
#      to_port     = 80
#    },
#    {
#      rule_number = 200
#      protocol    = "tcp"
#      rule_action = "allow"
#      cidr_block  = local.worker_cidr
#      from_port   = 443
#      to_port     = 443
#    },
#    {
#      rule_number = 300
#      protocol    = "tcp"
#      rule_action = "allow"
#      cidr_block  = "0.0.0.0/0"
#      from_port   = 1024
#      to_port     = 65535
#    }
#  ]
#  nacl_rules_egress = [
#    {
#      rule_number = 100
#      protocol    = "tcp"
#      rule_action = "allow"
#      cidr_block  = "0.0.0.0/0"
#      from_port   = 1024
#      to_port     = 65535
#    }
#  ]
#}
#
#module "alb_a_nacl" {
#  source = "../modules/network/nacl"
#
#  create_nacl = true
#  name        = "${var.project_name}-${var.env}-alb-a"
#  vpc_id      = module.main_vpc.id
#  subnet_id   = module.alb_a_subnet.id
#  nacl_rules_ingress = [
#    {
#      rule_number = 100
#      protocol    = "tcp"
#      rule_action = "allow"
#      cidr_block  = local.worker_cidr
#      from_port   = 80
#      to_port     = 80
#    },
#    {
#      rule_number = 200
#      protocol    = "tcp"
#      rule_action = "allow"
#      cidr_block  = local.worker_cidr
#      from_port   = 443
#      to_port     = 443
#    },
#    {
#      rule_number = 300
#      protocol    = "tcp"
#      rule_action = "allow"
#      cidr_block  = "0.0.0.0/0"
#      from_port   = 1024
#      to_port     = 65535
#    }
#  ]
#  nacl_rules_egress = [
#    {
#      rule_number = 100
#      protocol    = "tcp"
#      rule_action = "allow"
#      cidr_block  = "0.0.0.0/0"
#      from_port   = 1024
#      to_port     = 65535
#    }
#  ]
#}
#
#module "alb_b_nacl" {
#  source = "../modules/network/nacl"
#
#  create_nacl = true
#  name        = "${var.project_name}-${var.env}-alb-b"
#  vpc_id      = module.main_vpc.id
#  subnet_id   = module.alb_b_subnet.id
#  nacl_rules_ingress = [
#    {
#      rule_number = 100
#      protocol    = "tcp"
#      rule_action = "allow"
#      cidr_block  = local.worker_cidr
#      from_port   = 80
#      to_port     = 80
#    },
#    {
#      rule_number = 200
#      protocol    = "tcp"
#      rule_action = "allow"
#      cidr_block  = local.worker_cidr
#      from_port   = 443
#      to_port     = 443
#    },
#    {
#      rule_number = 300
#      protocol    = "tcp"
#      rule_action = "allow"
#      cidr_block  = "0.0.0.0/0"
#      from_port   = 1024
#      to_port     = 65535
#    }
#  ]
#  nacl_rules_egress = [
#    {
#      rule_number = 100
#      protocol    = "tcp"
#      rule_action = "allow"
#      cidr_block  = "0.0.0.0/0"
#      from_port   = 1024
#      to_port     = 65535
#    }
#  ]
#}
#
#module "dp_nacl" {
#  source = "../modules/network/nacl"
#
#  create_nacl = true
#  name        = "${var.project_name}-${var.env}-dp"
#  vpc_id      = module.main_vpc.id
#  subnet_id   = module.worker_subnet.id
#  nacl_rules_ingress = [
#    {
#      rule_number = 100
#      protocol    = "tcp"
#      rule_action = "allow"
#      cidr_block  = local.worker_cidr
#      from_port   = 80
#      to_port     = 80
#    },
#    {
#      rule_number = 200
#      protocol    = "tcp"
#      rule_action = "allow"
#      cidr_block  = local.worker_cidr
#      from_port   = 443
#      to_port     = 443
#    },
#    {
#      rule_number = 300
#      protocol    = "tcp"
#      rule_action = "allow"
#      cidr_block  = "0.0.0.0/0"
#      from_port   = 1024
#      to_port     = 65535
#    }
#  ]
#  nacl_rules_egress = [
#    {
#      rule_number = 100
#      protocol    = "tcp"
#      rule_action = "allow"
#      cidr_block  = "0.0.0.0/0"
#      from_port   = 1024
#      to_port     = 65535
#    }
#  ]
#}
