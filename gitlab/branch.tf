locals {
  branches_to_create = setsubtract(distinct(concat(var.additional_branches, [var.source_branch], [var.default_branch])), ["master"])
}

resource "null_resource" "create_branch" {
  for_each = toset(local.branches_to_create)

  depends_on = [
    gitlab_project.project
  ]

  provisioner "local-exec" {
    command = "curl -H 'PRIVATE-TOKEN: ${var.gitlab_token}' -X POST 'https://gitlab.com/api/v4/projects/${gitlab_project.project.id}/repository/branches?branch=${each.value}&ref=${var.source_branch}'"
  }
}

resource "null_resource" "update_default_branch" {
  depends_on = [
    gitlab_project.project,
    null_resource.create_branch
  ]

  triggers = {
    default_branch = var.default_branch
  }

  provisioner "local-exec" {
    command = "curl -H 'PRIVATE-TOKEN: ${var.gitlab_token}' -X PUT --data 'default_branch=${var.default_branch}' 'https://gitlab.com/api/v4/projects/${gitlab_project.project.id}'"
  }
}

resource "null_resource" "unprotect_branch" {
  for_each = setsubtract(toset(var.branches_to_unprotect), toset(keys(var.branches_to_protect)))

  depends_on = [
    gitlab_project.project,
    null_resource.create_branch,
    null_resource.update_default_branch
  ]

  triggers = {
    branches_to_unprotect = join(", ", var.branches_to_unprotect)
  }

  provisioner "local-exec" {
    command = "curl -H 'PRIVATE-TOKEN: ${var.gitlab_token}' -X DELETE 'https://gitlab.com/api/v4/projects/${gitlab_project.project.id}/protected_branches/${each.value}'"
  }
}

resource "null_resource" "unprotect_master_branch" {
  depends_on = [
    gitlab_project.project,
    null_resource.create_branch,
    null_resource.update_default_branch
  ]

  triggers = {
    branch_to_unprotect = "master"
  }

  provisioner "local-exec" {
    command = "curl -H 'PRIVATE-TOKEN: ${var.gitlab_token}' -X DELETE 'https://gitlab.com/api/v4/projects/${gitlab_project.project.id}/protected_branches/master'"
  }
}

resource "null_resource" "delete_branch" {
  for_each = setsubtract(toset(var.branches_to_delete), toset(local.branches_to_create))

  depends_on = [
    gitlab_project.project,
    null_resource.create_branch,
    null_resource.unprotect_branch,
    null_resource.update_default_branch
  ]

  triggers = {
    branches_to_delete = join(", ", var.branches_to_delete)
  }

  provisioner "local-exec" {
    command = "curl -H 'PRIVATE-TOKEN: ${var.gitlab_token}' -X DELETE 'https://gitlab.com/api/v4/projects/${gitlab_project.project.id}/repository/branches/${each.value}'"
  }
}

resource "null_resource" "delete_master_branch" {
  for_each = setsubtract(toset(var.default_branch == "master" ? [] : ["master"]), local.branches_to_create)

  depends_on = [
    gitlab_project.project,
    null_resource.create_branch,
    null_resource.update_default_branch,
    null_resource.unprotect_master_branch
  ]

  triggers = {
    branch_to_delete = "master"
  }

  provisioner "local-exec" {
    command = "curl -H 'PRIVATE-TOKEN: ${var.gitlab_token}' -X DELETE 'https://gitlab.com/api/v4/projects/${gitlab_project.project.id}/repository/branches/master'"
  }
}
