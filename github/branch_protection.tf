resource "github_branch_protection" "branch_protection" {
  for_each               = var.branches_to_protect
  repository_id          = github_repository.repo.node_id
  pattern                = each.key
  enforce_admins         = each.value.enforce_admins
  require_signed_commits = each.value.require_signed_commits
  push_restrictions      = each.value.push_restrictions

  required_status_checks {
    strict   = each.value.up_to_date
    contexts = each.value.status_check_contexts
  }

  dynamic "required_pull_request_reviews" {
    for_each = each.value.require_pull_request_reviews ? [each.value.require_pull_request_reviews] : []
    content {
      dismiss_stale_reviews           = each.value.dismiss_stale_reviews
      dismissal_restrictions          = each.value.dismissal_restrictions
      require_code_owner_reviews      = each.value.require_code_owner_reviews
      required_approving_review_count = each.value.required_approving_review_count == 0 ? 1 : each.value.required_approving_review_count
    }
  }

  depends_on = [
    github_branch.branch
  ]
}
