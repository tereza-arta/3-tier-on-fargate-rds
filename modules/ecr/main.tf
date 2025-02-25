resource "aws_ecr_repository" "different" {
  count = var.ecr_cnt
  name = var.repo_name
  image_tag_mutability = var.mutability
}

data "aws_caller_identity" "current" {}

resource "aws_ecr_lifecycle_policy" "example" {
  count = var.ecr_cnt
  repository = aws_ecr_repository.different[count.index].name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 3 images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 3
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

resource "terraform_data" "dkr_pack" {
  count = var.tf_data_dkr_pack ? 1 : 0
  provisioner "local-exec" {
    command = <<EOF
    aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.eu-north-1.amazonaws.com
    a = var.build_arg
    if [ !$a ]; then docker build -t "${aws_ecr_repository.different[var.index].repository_url}:${var.image_tag}" -f "${var.df_context}/Dockerfile" .; fi
    if [ $a ]; then docker build --build-arg "SRV_IP=13.61.21.216" -t "${aws_ecr_repository.different[var.index].repository_url}:${var.image_tag}" -f "${var.df_context}/Dockerfile" .; fi
    docker push "${aws_ecr_repository.different[var.index].repository_url}:${var.image_tag}"
    EOF
  }
  triggers_replace = {
    "run_at" = timestamp()
  }
  #depends_on = [var.dkr_pack_dependency]
}

