module "frontend" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/iamkatikam/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    
    sg_name = var.frontend_sg_name
    sg_description = var.frontend_sg_name_description
    sg_tags = var.sg_tags
    vpc_id = local.vpc_id

}


module "bastion" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/iamkatikam/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    
    sg_name = var.bastion_sg_name
    sg_description = var.bastion_sg_description
    sg_tags = var.sg_tags
    vpc_id = local.vpc_id

}

module "backend_alb" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/iamkatikam/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    
    sg_name = "backend-alb"
    sg_description = "security group for backend Application Load Balancer"
    sg_tags = var.sg_tags
    vpc_id = local.vpc_id

}

module "vpn" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/iamkatikam/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    
    sg_name = "vpn"
    sg_description = "security group for vpn"
    sg_tags = var.sg_tags
    vpc_id = local.vpc_id

}

module "mongodb" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/iamkatikam/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    
    sg_name = "mongodb"
    sg_description = "security group for mongodb"
    sg_tags = var.sg_tags
    vpc_id = local.vpc_id

}

module "redis" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/iamkatikam/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    
    sg_name = "redis"
    sg_description = "security group for redis"
    sg_tags = var.sg_tags
    vpc_id = local.vpc_id

}

module "mysql" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/iamkatikam/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    
    sg_name = "mysql"
    sg_description = "security group for mysql"
    sg_tags = var.sg_tags
    vpc_id = local.vpc_id

}

module "rabbitmq" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/iamkatikam/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    
    sg_name = "rabbitmq"
    sg_description = "security group for rabbitmq"
    sg_tags = var.sg_tags
    vpc_id = local.vpc_id

}


#allow connections from laptop to bastion host
resource "aws_security_group_rule" "bastion_laptop" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}

#backend ALB accepting connections from bastion host on port 80
resource "aws_security_group_rule" "backend_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.backend_alb.sg_id
}

#VPN ports 22, 443, 1194, 943
resource "aws_security_group_rule" "vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
  
}

resource "aws_security_group_rule" "backend_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "mongodb_vpn_ssh" {
  count = length(var.mongodb_vpn_ports)
  type              = "ingress"
  from_port         = var.mongodb_vpn_ports[count.index]
  to_port           = var.mongodb_vpn_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.mongodb.sg_id
}

resource "aws_security_group_rule" "redis_vpn_ssh" {
  count = length(var.redis_vpn_ports)
  type              = "ingress"
  from_port         = var.redis_vpn_ports[count.index]
  to_port           = var.redis_vpn_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.redis.sg_id
}


resource "aws_security_group_rule" "mysql_vpn_ssh" {
  count = length(var.mysql_vpn_ports)
  type              = "ingress"
  from_port         = var.mysql_vpn_ports[count.index]
  to_port           = var.mysql_vpn_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.mysql.sg_id
}

resource "aws_security_group_rule" "rabbitmq_vpn_ssh" {
  count = length(var.rabbitmq_vpn_ports)
  type              = "ingress"
  from_port         = var.rabbitmq_vpn_ports[count.index]
  to_port           = var.rabbitmq_vpn_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.rabbitmq.sg_id
}
