module "example_repo" {
  source = "../terraform"

  repository_name     = "example_repo"
  description         = "Some random description here"
  default_branch      = "main"
  additional_branches = ["gh-pages"]

  users = {
    "octokit" = { permission = "pull" }
  }

  labels = {
    "these-are-example"   = "0e8a16"
    "labels-in-different" = "D9534F"
    "colors"              = "555555"
  }

  branches_to_protect = {
    "main" = {
      enforce_admins        = false
      up_to_date            = true
      status_check_contexts = ["test", "codeclimate"]
    }
    "gh-pages" = {
      enforce_admins        = false
      up_to_date            = true
      status_check_contexts = []
    }
  }
}
