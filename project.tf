locals {
  tags            = concat(var.tags, ["managed-by-terraform"])
  group_namespace = length(var.gitlab_group) > 0 ? [var.gitlab_group] : []
}

data "gitlab_group" "namespace" {
  for_each  = toset(local.group_namespace)
  full_path = each.value
}

resource "gitlab_project" "project" {
  name                                  = var.project_name
  namespace_id                          = length(var.gitlab_group) > 0 ? data.gitlab_group.namespace[var.gitlab_group].id : null
  visibility_level                      = var.visibility
  description                           = var.description
  initialize_with_readme                = var.initial_readme
  archived                              = var.archived
  tags                                  = local.tags
  issues_enabled                        = var.issues
  merge_requests_enabled                = var.merge_requests
  pipelines_enabled                     = var.pipelines
  wiki_enabled                          = var.wiki
  container_registry_enabled            = var.container_registry
  snippets_enabled                      = var.snippets
  approvals_before_merge                = var.required_approvals
  only_allow_merge_if_pipeline_succeeds = var.require_pipeline_successful
  merge_method                          = var.merge_method
  remove_source_branch_after_merge      = var.delete_branch_after_merge
}
