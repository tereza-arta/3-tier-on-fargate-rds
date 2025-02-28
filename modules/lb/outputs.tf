#Load balancer
#Same with arn of lb
output "lb_id" {
  value = aws_lb.some.*.id
}

output "dns_name_1" {
  value = aws_lb.some[0].dns_name
}

output "dns_name_2" {
  value = aws_lb.some[1].dns_name
}

#Target group
output "tg_id" {
  value = aws_lb_target_group.some.*.id
}

output "tg_arn_1" {
  value = aws_lb_target_group.some[0].arn
}

output "tg_arn_2" {
  value = aws_lb_target_group.some[1].arn
}


output "tg_name" {
  value = aws_lb_target_group.some.*.name
}
