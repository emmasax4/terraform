locals {
  topics = concat(var.topics, ["managed-by-terraform"])
}

resource "github_repository" "repo" {
  name                   = var.repository_name
  visibility             = var.visibility
  description            = var.description
  homepage_url           = var.homepage_url
  is_template            = var.is_template
  topics                 = local.topics
  has_issues             = var.issues
  has_projects           = var.projects
  has_wiki               = var.wiki
  has_downloads          = var.downloads
  allow_merge_commit     = var.merge_commit
  allow_squash_merge     = var.squash_commit
  allow_rebase_merge     = var.rebase_commit
  delete_branch_on_merge = var.delete_branch_on_merge
  auto_init              = true

  lifecycle {
    ignore_changes = [auto_init, archived]
  }
}
