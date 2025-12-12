module "vpc"{
    source = "./modules/vpc"
    vpc_cidr = var.vpc_cidr
    subnets =  var.subnets
}


module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "ec2"{
  source = "./modules/ec2"
  subnet_id = module.vpc.subnet_id
  sg_id = module.sg.sg_id
}

module "alb" {
  source = "./modules/alb"
  sg_id = module.sg.sg_id
  subnets = module.vpc.subnet_id
  vpc_id = module.vpc.vpc_id
  instance_id = module.ec2.instance_id
}