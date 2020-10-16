locals {
  branches      = setsubtract(distinct(concat(var.additional_branches, [var.source_branch], [var.default_branch])), ["main"])
  delete_branch = var.default_branch == "main" ? [] : ["main"]
}

resource "github_branch" "branch" {
  for_each      = toset(local.branches)
  repository    = github_repository.repo.name
  branch        = each.value
  source_branch = var.source_branch

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      branch,
      source_branch
    ]
  }
}

resource "null_resource" "update_default_branch" {
  depends_on = [
    github_repository.repo,
    github_branch.branch
  ]

  triggers = {
    default_branch = var.default_branch
  }

  provisioner "local-exec" {
    command = "curl -H 'Authorization: token ${var.github_token}' --request PATCH --data '{\"default_branch\": \"${var.default_branch}\" }' https://api.github.com/repos/${var.owner}/${github_repository.repo.name}"
  }
}

resource "null_resource" "delete_main_branch" {
  for_each = setsubtract(toset(local.delete_branch), local.branches)

  depends_on = [
    github_repository.repo,
    github_branch.branch,
    null_resource.update_default_branch
  ]

  triggers = {
    branch_to_delete = "main"
  }

  provisioner "local-exec" {
    command = "curl -H 'Authorization: token ${var.github_token}' -X DELETE https://api.github.com/repos/${var.owner}/${github_repository.repo.name}/git/refs/heads/main"
  }
}
