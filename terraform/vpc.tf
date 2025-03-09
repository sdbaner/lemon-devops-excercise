module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.18.1"
  name = var.vpc
  cidr = var.vpc_cidr

  azs             = ["eu-central-1a", "eu-central-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway  = true
  single_nat_gateway  = true 
  #enable_vpn_gateway = true

  tags = {
    Terraform                                     = "true"
    Environment                                   = "dev"
    Project                                       = "lemon"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"    
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

}


