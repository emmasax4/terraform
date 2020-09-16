resource "gitlab_branch_protection" "branch_protection" {
  for_each           = var.branches_to_protect
  project            = gitlab_project.project.id
  branch             = each.key
  push_access_level  = each.value.push_access
  merge_access_level = each.value.merge_access

  depends_on = [
    null_resource.gitlab_branch
  ]
}

# TODO: update documentation for branch protection
# no one, developer, maintainer
