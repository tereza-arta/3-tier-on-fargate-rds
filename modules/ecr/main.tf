resource "aws_ecr_repository" "different" {
  count                = var.ecr_cnt
  name                 = var.repo_name
  image_tag_mutability = var.mutability
}

data "aws_caller_identity" "current" {}

data "template_file" "policy" {
  template = file("${path.module}/templates/ecr/lifecycle-policy.json.tpl")
}

resource "aws_ecr_lifecycle_policy" "example" {
  count      = var.ecr_cnt
  repository = aws_ecr_repository.different[count.index].name
  policy = data.template_file.policy.rendered
}

resource "terraform_data" "dkr_pack" {
  count = var.tf_data_dkr_pack ? 1 : 0
  provisioner "local-exec" {
    command = <<EOF
    aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.eu-north-1.amazonaws.com
    docker build --build-arg "SRV_IP=${var.srv_addr}" -t "${aws_ecr_repository.different[var.index].repository_url}:${var.image_tag}" -f "${var.df_context}/Dockerfile" .
    docker push "${aws_ecr_repository.different[var.index].repository_url}:${var.image_tag}"
    EOF
  }
  triggers_replace = {
    "run_at" = timestamp()
  }
}

