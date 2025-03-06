output "rds_endpoint" {
  value = aws_db_instance.this.*.endpoint
}

output "rds_0_endpoint" {
  value = aws_db_instance.this[0].endpoint
}

output "rds_0_addr" {
  value = aws_db_instance.this[0].address
}

output "username" {
  value = aws_db_instance.this[0].username
}

output "password" {
  value = aws_db_instance.this[0].password
}

output "db_name" {
  value = aws_db_instance.this[0].db_name
}
