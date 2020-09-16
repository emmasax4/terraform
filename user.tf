data "gitlab_user" "user" {
  for_each = var.users
  username = each.key
}

resource "gitlab_project_membership" "user" {
  for_each     = var.users
  project_id   = gitlab_project.project.id
  user_id      = data.gitlab_user.user[each.key].id
  access_level = each.value.permission

  depends_on = [
    data.gitlab_user.user
  ]
}

# TODO: update documentation for users
# guest, reporter, developer, maintainer
