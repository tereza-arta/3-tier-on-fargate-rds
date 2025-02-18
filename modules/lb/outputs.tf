#Load balancer
#Same with arn of lb
output "lb_id" {
  value = aws_lb.some.*.id
}

output "dns_name" {
  value = aws_lb.some.*.dns_name
}

#Target group
output "tg_id" {
  value = aws_lb_target_group.some.*.id
}

output "tg_arn" {
  value = aws_lb_target_group.some.*.arn
}

output "tg_name" {
  value = aws_lb_target_group.some.*.name
}
