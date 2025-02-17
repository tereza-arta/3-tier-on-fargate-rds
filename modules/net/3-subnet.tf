data "aws_availability_zones" "az" {}

resource "aws_subnet" "pub" {
  count = var.pub_sub_cnt
  #vpc_id = aws_vpc.vpc.id
  #vpc_id = var.pub_sub_vpc_id
  vpc_id = "${local.vpc-id}"
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.az.names[count.index]
  map_public_ip_on_launch = var.map_public_ip
  ipv6_native = var.only_ipv6

  tags = {
    Name = "${var.pub_sub_tag}-${count.index + 1}"
  }
}

resource "aws_subnet" "priv" {
  count = var.priv_sub_cnt
  #vpc_id = aws_vpc.vpc.id
  #vpc_id = var.priv_sub_vpc_id
  vpc_id = "${local.vpc-id}"
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, var.az_cnt + count.index)
  availability_zone = data.aws_availability_zones.az.names[count.index]
  ipv6_native = var.only_ipv6

  tags = {
    Name = "${var.priv_sub_tag}-${count.index + 1}"
  }
}
