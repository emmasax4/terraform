locals {
  tags = concat(var.tags, ["managed-by-terraform"])
  # group_ids = var.group_id > 0 ? [tostring(var.group_id)] : []
  # namespace = var.group_id > 0 ? gitlab_group.namespace.id : null
}

# data "gitlab_group" "namespace" {
#   for_each = toset(local.group_ids)
#   group_id = tonumber(each.value)
# }

# data "gitlab_user" "user" {
#   username = var.gitlab_namespace # if the namespace owner is there...
# }

resource "gitlab_project" "project" {
  name                                  = var.project_name
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

  # TODO: make the terraform work with both user accounts and gitlab groups

  # namespace_id = data.gitlab_user.user.id

  # lifecycle {
  #   ignore_changes = [
  #     auto_init
  #   ]
  # }
}
