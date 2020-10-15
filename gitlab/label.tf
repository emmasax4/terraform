resource "gitlab_label" "label" {
  for_each = var.labels
  project  = gitlab_project.project.id
  name     = each.key
  color    = "#${each.value}"
}
