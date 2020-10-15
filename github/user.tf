resource "github_repository_collaborator" "user" {
  for_each   = var.users
  username   = each.key
  repository = github_repository.repo.name
  permission = each.value.permission
}
