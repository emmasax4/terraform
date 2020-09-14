module "example_repo" {
  source = "../terraform"

  repository_name     = "example_repo"
  description         = "Some random description here"
  visibility          = "public"
  default_branch      = "main"
  additional_branches = ["other-branch"]

  users = {
    "akw7" = { permission = "push" }
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
    "other-branch" = {
      enforce_admins        = false
      up_to_date            = true
      status_check_contexts = []
    }
  }
}
