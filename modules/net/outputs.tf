#VPC outputs
output "def_vpc_id" {
  value = aws_default_vpc.vpc.id
}

output "def_vpc_arn" {
  value = aws_default_vpc.vpc.arn
}

output "def_vpc_cidr" {
  value = aws_default_vpc.vpc.cidr_block
}

output "vpc_id" {
  value = aws_vpc.vpc.*.id
}

output "vpc_arn" {
  value = aws_vpc.vpc.*.arn
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

#Internet Gateway outputs
output "igw_id" {
  value = aws_internet_gateway.igw.*.id
}

output "igw_arn" {
  value = aws_internet_gateway.igw.*.arn
}

output "account_owner_id" {
  value = aws_internet_gateway.igw.*.owner_id
}

#Subnet outputs
output "pub_sub_id" {
  value = aws_subnet.pub.*.id
}

output "pub_sub_arn" {
  value = aws_subnet.pub.*.arn
}

output "priv_sub_id" {
  value = aws_subnet.priv.*.id
}

output "priv_sub_arn" {
  value = aws_subnet.priv.*.arn
}

