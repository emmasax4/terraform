data "gitlab_user" "additional_users" {
  for_each = var.additional_users
  username = each.key
}

resource "gitlab_project_membership" "user" {
  for_each     = var.additional_users
  project_id   = gitlab_project.project.id
  user_id      = data.gitlab_user.additional_users[each.key].id
  access_level = each.value.permission

  depends_on = [
    data.gitlab_user.additional_users
  ]
}

# TODO: update documentation for users
# guest, reporter, developer, maintainer
