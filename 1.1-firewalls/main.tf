module "vpn_sg" {
    source = "git::https://github.com/sivadevopsdaws74s/terraform-aws-securitygroup.git"
    project_name = var.project_name
    sg_name = "roboshop-vpn"
    sg_description = "Allowing All ports from my Home IP"
    vpc_id = data.aws_vpc.default.id
    common_tags = merge(
        {
            Name = "Roboshop-VPN"
            Component = "VPN"
        },
        var.common_tags
    )
}


module "mongodb_sg" {
    source = "../../terraform-aws-securitygroup-mod"
    project_name = var.project_name
    sg_name = "mongodb"
    sg_description = "Allowing traffic"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
        {
            Name = "Mongodb"
            Component = "MongoDB"
        },
        var.common_tags
    )    
}

module "catalogue_sg" {
    source = "../../terraform-aws-securitygroup-mod"
    project_name = var.project_name
    sg_name = "catalogue"
    sg_description = "Allowing traffic"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
        {
            Name = "Catalogue"
            Component = "Catalogue"
        },
        var.common_tags
    )    
}

module "user_sg" {
  
  source = "../../terraform-aws-securitygroup-mod"
  project_name = var.project_name
  sg_name = "user"
  sg_description = "Allowing Traffic"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
    var.common_tags,
    {
        Component = "user",
        Name = "user"
    }
  )
}

module "web_sg" {
  
  source = "../../terraform-aws-securitygroup-mod"
  project_name = var.project_name
  sg_name = "web"
  sg_description = "Allowing Traffic"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
    var.common_tags,
    {
        Component = "web",
        Name = "web"
    }
  )
}

module "app_alb_sg" {
  source = "../../terraform-aws-securitygroup-mod"
  project_name = var.project_name
  sg_name = "app_alb"
  sg_description = "allowing traffic"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = merge(
    var.common_tags,
    {
        Component = "app",
        Name = "app_alb"
    }
  )
}

module "web_alb_sg" {
  source = "../../terraform-aws-securitygroup-mod"
  project_name = var.project_name
  sg_name = "web_alb"
  sg_description = "Allowing Traffic"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
    var.common_tags,
    {
        Component = "web",
        Name = "web_alb"
    }
  )
  
}
module "redis_sg" {
  source = "../../terraform-aws-securitygroup-mod"
  project_name = var.project_name
  sg_name = "redis"
  sg_description = "Allowing Traffic"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
    var.common_tags,
    {
        Component = "redis",
        Name = "redis"
    }
  )
  
}
module "mysql_sg" {
  source = "../../terraform-aws-securitygroup-mod"
  project_name = var.project_name
  sg_name = "mysql"
  sg_description = "Allowing Traffic"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
    var.common_tags,
    {
        Component = "mysql",
        Name = "mysql"
    }
  )
  
}
module "rabbitmq_sg" {
  source = "../../terraform-aws-securitygroup-mod"
  project_name = var.project_name
  sg_name = "rabbitmq"
  sg_description = "Allowing Traffic"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
    var.common_tags,
    {
        Component = "rabbitmq",
        Name = "rabbitmq"
    }
  )
  
}
module "cart_sg" {
  source = "../../terraform-aws-securitygroup-mod"
  project_name = var.project_name
  sg_name = "cart"
  sg_description = "Allowing Traffic"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
    var.common_tags,
    {
        Component = "cart",
        Name = "cart"
    }
  )
  
}
module "shipping_sg" {
  source = "../../terraform-aws-securitygroup-mod"
  project_name = var.project_name
  sg_name = "shipping"
  sg_description = "Allowing Traffic"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
    var.common_tags,
    {
        Component = "shipping",
        Name = "shipping"
    }
  )
  
}
module "payment_sg" {
  source = "../../terraform-aws-securitygroup-mod"
  project_name = var.project_name
  sg_name = "payment"
  sg_description = "Allowing Traffic"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
    var.common_tags,
    {
        Component = "payment",
        Name = "payment"
    }
  )
  
}

resource "aws_security_group_rule" "vpn" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.vpn_sg.security_group_id
}


resource "aws_security_group_rule" "mongodb_catalogue" {
  type              = "ingress"
  description       = "Allowing port 27017 from catalogue"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.catalogue_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.mongodb_sg.security_group_id
}

resource "aws_security_group_rule" "mongodb_vpn" {
  type              = "ingress"
  description       = "Allowing port 22 from vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.mongodb_sg.security_group_id
}

resource "aws_security_group_rule" "mongodb_user" {
  type              = "ingress"
  description       = "Allowing port 27017 from user"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.user_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.mongodb_sg.security_group_id
}

resource "aws_security_group_rule" "redis_user" {
  type              = "ingress"
  description       = "Allowing port 22 from user"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.user_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.redis_sg.security_group_id
}

resource "aws_security_group_rule" "redis_vpn" {
  type              = "ingress"
  description       = "Allowing port 6379 from vpn"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.redis_sg.security_group_id
}

resource "aws_security_group_rule" "redis_cart" {
  type              = "ingress"
  description       = "Allowing port 6379 from vpn"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.cart_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.redis_sg.security_group_id
}

resource "aws_security_group_rule" "mysql_vpn" {
  type              = "ingress"
  description       = "Allowing port 6379 from vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.mysql_sg.security_group_id
}

resource "aws_security_group_rule" "mysql_shipping" {
  type              = "ingress"
  description       = "Allowing port 3306 from shipping"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.shipping_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.mysql_sg.security_group_id
}

resource "aws_security_group_rule" "rabbitmq_payment" {
  type              = "ingress"
  description       = "Allowing port 5672 from payment"
  from_port         = 5672
  to_port           = 5672
  protocol          = "tcp"
  source_security_group_id = module.payment_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.rabbitmq_sg.security_group_id
}

resource "aws_security_group_rule" "rabbitmq_vpn" {
  type              = "ingress"
  description       = "Allowing port 22 from vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.rabbitmq_sg.security_group_id
}


resource "aws_security_group_rule" "catalogue_app_alb" {
  type = "ingress"
  description = "allowing port number 8080 from app_alb"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  #cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = module.app_alb_sg.security_group_id
  security_group_id = module.catalogue_sg.security_group_id    
}

resource "aws_security_group_rule" "catalogue_vpn" {
  type = "ingress"
  description = "allowing port number 22 from vpn"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  #cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = module.vpn_sg.security_group_id
  security_group_id = module.catalogue_sg.security_group_id    
}

resource "aws_security_group_rule" "user_app_alb" {
  type = "ingress"
  description = "allowing port number 8080 from app_alb"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  #cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = module.app_alb_sg.security_group_id
  security_group_id = module.user_sg.security_group_id     
  
}

resource "aws_security_group_rule" "user_vpn" {
  type = "ingress"
  description = "allowing port number 22 from vpn"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  #cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = module.vpn_sg.security_group_id
  security_group_id = module.user_sg.security_group_id    
  
}

resource "aws_security_group_rule" "cart_vpn" {
  type = "ingress"
  description = "allowing port number 22 from vpn"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  #cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = module.vpn_sg.security_group_id
  security_group_id = module.cart_sg.security_group_id    
  
}

resource "aws_security_group_rule" "cart_app_alb" { 
  type = "ingress"
  description = "allowing port number 8080 from app_alb"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  #cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = module.app_alb_sg.security_group_id
  security_group_id = module.cart_sg.security_group_id   
}

resource "aws_security_group_rule" "shipping_vpn" {
  type = "ingress"
  description = "allowing port number 22 from vpn"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  #cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = module.vpn_sg.security_group_id
  security_group_id = module.shipping_sg.security_group_id    
  
}

resource "aws_security_group_rule" "shipping_app_alb" {
  type = "ingress"
  description = "allowing port number 8080 from App Alb"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  #cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = module.app_alb_sg.security_group_id
  security_group_id = module.shipping_sg.security_group_id    
  
}

resource "aws_security_group_rule" "payment_vpn" {
  type = "ingress"
  description = "allowing port number 22 from vpn"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  #cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = module.vpn_sg.security_group_id
  security_group_id = module.payment_sg.security_group_id    
  
}

resource "aws_security_group_rule" "payment_app_alb" {
  type = "ingress"
  description = "allowing port number 8080 from App alb"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  #cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = module.app_alb_sg.security_group_id
  security_group_id = module.payment_sg.security_group_id    
  
}

resource "aws_security_group_rule" "app_alb_vpn" {
  type = "ingress"
  description = "allowing port number 80 from vpn"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  #cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = module.vpn_sg.security_group_id
  security_group_id = module.app_alb_sg.security_group_id     
  
}

resource "aws_security_group_rule" "app_alb_web" {
  type = "ingress"
  description = "allowing port number 80 from web"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  #cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = module.web_sg.security_group_id
  security_group_id = module.app_alb_sg.security_group_id     
}

resource "aws_security_group_rule" "app_alb_catalogue" {
  type = "ingress"
  description = "allowing port number 80 from catalogue"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  #cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = module.catalogue_sg.security_group_id
  security_group_id = module.app_alb_sg.security_group_id   
}

resource "aws_security_group_rule" "app_alb_user" {
  type = "ingress"
  description = "allowing port number 80 from user"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  #cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = module.user_sg.security_group_id
  security_group_id = module.app_alb_sg.security_group_id   
}

resource "aws_security_group_rule" "app_alb_cart" {
  type = "ingress"
  description = "allowing port number 80 from cart"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  #cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = module.cart_sg.security_group_id
  security_group_id = module.app_alb_sg.security_group_id   
}

resource "aws_security_group_rule" "app_alb_shipping" {
  
  type = "ingress"
  description = "allowing port number 80 from shipping"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  #cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = module.shipping_sg.security_group_id
  security_group_id = module.app_alb_sg.security_group_id   
}

resource "aws_security_group_rule" "app_alb_payment" {
  
  type = "ingress"
  description = "allowing port number 80 from payment"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  #cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = module.payment_sg.security_group_id
  security_group_id = module.app_alb_sg.security_group_id   
}

resource "aws_security_group_rule" "web_vpn" {
  type = "ingress"
  description = "allowing port number 80 from vpn"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  #cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = module.vpn_sg.security_group_id
  security_group_id = module.web_sg.security_group_id   
  
}

resource "aws_security_group_rule" "web_vpn_ssh" {
  type = "ingress"
  description = "allowing port number 22 from vpn_ssh"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  #cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = module.vpn_sg.security_group_id
  security_group_id = module.web_sg.security_group_id     
}

resource "aws_security_group_rule" "web_web_alb" {
  type = "ingress"
  description = "allowing port number 80 from web_alb"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  #cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = module.web_alb_sg.security_group_id
  security_group_id = module.web_sg.security_group_id    
}

resource "aws_security_group_rule" "web_alb_internet" {
  type = "ingress"
  description = "allowing port number 80 from internet"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.web_alb_sg.security_group_id  
}

resource "aws_security_group_rule" "web_alb_internet_https" {
  type = "ingress"
  description = "allowing port number 443 from internet"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.web_alb_sg.security_group_id
  
}