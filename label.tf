resource "github_issue_label" "label" {
  for_each   = var.labels
  repository = github_repository.repo.name
  name       = each.key
  color      = each.value
}
