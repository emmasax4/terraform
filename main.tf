locals {
  github_token = yamldecode(file("~/.git_config.yml"))[":github_token"]
}

provider "github" {
  token   = local.github_token
  owner   = var.github_owner
  version = "2.9.0"
}
