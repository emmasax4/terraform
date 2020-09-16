# TODO: make switching default branches easier (including deleting branches and unprotecting default-branches-to-be-deleted)
# to change default branches:
# - change default_branch variable to new branch
# - set source_branch to old default branch
# - optionally, protec the new default branch
# - run tf
# - remove source_branch
# - add delete_branches with old default branch
# - add unprotect_branches with old default branch
# - run tf
# - remove delete_branches and unprotect_branches

locals {
  branches      = setsubtract(distinct(concat(var.additional_branches, [var.source_branch], [var.default_branch])), ["master"])
  delete_branch = var.default_branch == "master" ? [] : ["master"]
}

resource "null_resource" "gitlab_branch" {
  for_each = toset(local.branches)

  depends_on = [
    gitlab_project.project
  ]

  provisioner "local-exec" {
    command = "curl -H 'PRIVATE-TOKEN: ${local.gitlab_token}' -X POST 'https://gitlab.com/api/v4/projects/${gitlab_project.project.id}/repository/branches?branch=${each.value}&ref=${var.source_branch}'"
  }
}

resource "null_resource" "update_default_branch" {
  depends_on = [
    gitlab_project.project,
    null_resource.gitlab_branch
  ]

  triggers = {
    default_branch = var.default_branch
  }

  provisioner "local-exec" {
    command = "curl -H 'PRIVATE-TOKEN: ${local.gitlab_token}' -X PUT --data 'default_branch=${var.default_branch}' 'https://gitlab.com/api/v4/projects/${gitlab_project.project.id}'"
  }
}

resource "null_resource" "unprotect_master_branch" {
  for_each = setsubtract(toset(local.delete_branch), local.branches)

  depends_on = [
    gitlab_project.project,
    null_resource.gitlab_branch,
    null_resource.update_default_branch
  ]

  triggers = {
    branch_to_unprotect = "master"
  }

  provisioner "local-exec" {
    command = "curl -H 'PRIVATE-TOKEN: ${local.gitlab_token}' -X DELETE 'https://gitlab.com/api/v4/projects/${gitlab_project.project.id}/protected_branches/master'"
  }
}

resource "null_resource" "delete_master_branch" {
  for_each = setsubtract(toset(local.delete_branch), local.branches)

  depends_on = [
    gitlab_project.project,
    null_resource.gitlab_branch,
    null_resource.update_default_branch,
    null_resource.unprotect_master_branch
  ]

  triggers = {
    branch_to_delete = "master"
  }

  provisioner "local-exec" {
    command = "curl -H 'PRIVATE-TOKEN: ${local.gitlab_token}' -X DELETE 'https://gitlab.com/api/v4/projects/${gitlab_project.project.id}/repository/branches/master'"
  }
}
