output "cluster_id" {
  value = aws_ecs_cluster.example[0].id
}

output "task_def_arn" {
  value = aws_ecs_task_definition.this[0].arn
}
