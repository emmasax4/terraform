locals {
  gitlab_token = yamldecode(file("~/.git_config.yml"))[":gitlab_token"]
}

provider "gitlab" {
  token   = local.gitlab_token
  version = "~> 2.11.0"
}
