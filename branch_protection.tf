# resource "github_branch_protection" "branch_protection" {
#   for_each       = var.branches_to_protect
#   repository     = github_repository.repo.name
#   branch         = each.key
#   enforce_admins = each.value.enforce_admins

#   required_status_checks {
#     strict   = each.value.up_to_date
#     contexts = each.value.status_check_contexts
#   }

#   depends_on = [
#     github_branch.branch
#   ]
# }
