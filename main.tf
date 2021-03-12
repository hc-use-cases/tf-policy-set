module "vpc" {
  source = "github.com/andrewpopa/terraform-aws-vpc"

  # VPC
  cidr_block          = "172.16.0.0/16"
  vpc_public_subnets  = ["172.16.10.0/24", "172.16.11.0/24", "172.16.12.0/24"]
  vpc_private_subnets = ["172.16.13.0/24", "172.16.14.0/24", "172.16.15.0/24"]
  vpc_tags = {
    vpc            = "my-aws-vpc"
    public_subnet  = "public-subnet"
    private_subnet = "private-subnet"
    internet_gw    = "my-internet-gateway"
    nat_gateway    = "nat-gateway"
  }
}

module "security-group" {
  source = "github.com/andrewpopa/terraform-aws-security-group"

  # Security group
  security_group_name        = "my-aws-security-group"
  security_group_description = "my-aws-security-group-descr"
  ingress_ports              = [443, 80]
  vpc_id                     = module.vpc.vpc_id
}

module "ec2" {
  source   = "github.com/andrewpopa/terraform-aws-ec2"
  ami_type = "ami-0c960b947cbb2dd16"
  ec2_instance = {
    type          = "t2.small"
    root_hdd_size = 50
    root_hdd_type = "gp2"
  }
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = module.security-group.sg_id
  public_ip              = true
  instance_count         = 2
  ec2_tags = {
    ec2 = "policy-set-use"
  }
}

resource "null_resource" "count" {
  count = 2
  triggers = {
    key = "value ${count.index}"
  }
}
