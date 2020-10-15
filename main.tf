locals {
  github_token = yamldecode(file("~/.git_config.yml"))[":github_token"]
}

provider "github" {
  token   = local.github_token
  owner   = var.owner
  version = "~> 3.0.0"
}
