module "example_repo" {
  # When running locally, use "../../github"
  source = "git@github.com:emmahsax/terraform.git//github?ref=main"

  # When running this example, put your own token in here
  github_token = "1234567890abcdefghi"

  repository_name     = "example_repo"
  description         = "Some random description here"
  visibility          = "public"
  default_branch      = "main"
  additional_branches = ["other-branch"]

  # If you run this, you may accidentally invite an actual GitHub user to your example repository
  users = {
    "github-user" = { permission = "push" }
  }

  labels = {
    "these-are-example"   = "0e8a16"
    "labels-in-different" = "D9534F"
    "colors"              = "555555"
  }

  branches_to_protect = {
    "main" = {
      enforce_admins                  = false
      up_to_date                      = true
      status_check_contexts           = ["travis-ci", "codeclimate"]
      require_code_owner_reviews      = false
      required_approving_review_count = 0
      require_signed_commits          = false
      dismiss_stale_reviews           = false
      require_pull_request_reviews    = false
      push_restrictions               = []
      dismissal_restrictions          = []
    }
    "other-branch" = {
      enforce_admins                  = false
      up_to_date                      = true
      status_check_contexts           = []
      require_code_owner_reviews      = false
      required_approving_review_count = 0
      require_signed_commits          = false
      dismiss_stale_reviews           = false
      require_pull_request_reviews    = false
      push_restrictions               = []
      dismissal_restrictions          = []
    }
  }
}
