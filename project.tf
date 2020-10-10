data "gitlab_group" "namespace" {
  for_each  = toset(length(var.group_owner) > 0 ? [var.group_owner] : [])
  full_path = each.value
}

resource "gitlab_project" "project" {
  name                                  = var.project_name
  namespace_id                          = length(var.group_owner) > 0 ? data.gitlab_group.namespace[var.group_owner].id : null
  default_branch                        = var.is_import ? var.default_branch : null
  visibility_level                      = var.visibility
  description                           = var.description
  initialize_with_readme                = true
  archived                              = var.archived
  tags                                  = concat(var.tags, ["managed-by-terraform"])
  issues_enabled                        = var.issues
  merge_requests_enabled                = var.merge_requests
  pipelines_enabled                     = var.pipelines
  wiki_enabled                          = var.wiki
  packages_enabled                      = var.packages
  container_registry_enabled            = var.container_registry
  snippets_enabled                      = var.snippets
  approvals_before_merge                = var.required_approvals
  only_allow_merge_if_pipeline_succeeds = var.require_pipeline_successful
  merge_method                          = var.merge_method
  remove_source_branch_after_merge      = var.delete_branch_after_merge

  lifecycle {
    ignore_changes = [
      initialize_with_readme
    ]
  }
}
