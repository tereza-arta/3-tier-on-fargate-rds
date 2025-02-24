output "repo_arn" {
  value = aws_ecr_repository.different.*.arn
}

output "repo_url" {
  value = aws_ecr_repository.different.*.repository_url
}

#output "thingy" {
#  value      = "whatever makes sense"
#  depends_on = [terraform_data.db_srv_dkr_pack]
#}

#output "dep_from_db_ip" {
#  value = "whatever makes sense"
#  depends_on = [terraform_data.get_db_pub_ip]
#}
