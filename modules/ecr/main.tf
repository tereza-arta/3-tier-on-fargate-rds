resource "aws_ecr_repository" "different" {
  count = var.ecr_cnt
  name = var.repo_name[count.index]
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

resource "terraform_data" "srv_dkr_pack" {
  count = length(var.df_context) - 2
  provisioner "local-exec" {
    command = <<EOF
    aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.eu-north-1.amazonaws.com
    docker build -t "${aws_ecr_repository.different[1].repository_url}:${var.image_tag}" -f "${var.df_context[1]}/Dockerfile" .
    docker push "${aws_ecr_repository.different[1].repository_url}:${var.image_tag}"
    EOF
  }
  triggers_replace = {
    "run_at" = timestamp()
  }
  #depends_on = [aws_ecr_repository.different[1]]
}

resource "terraform_data" "fnt_dkr_pack" {
  provisioner "local-exec" {
    command = <<EOF
    aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.eu-north-1.amazonaws.com
    docker build --build-arg "SRV_IP=${var.fnt_lb_dns_name[0]}"  -t "${aws_ecr_repository.different[2].repository_url}:${var.image_tag}" -f "${var.df_context[2]}/Dockerfile" .
    docker push "${aws_ecr_repository.different[2].repository_url}:${var.image_tag}"
    EOF
  }
  triggers_replace = {
    "run_at" = timestamp()
  }
  #depends_on = [var.fnt_dkr_pack_dependency]
}
