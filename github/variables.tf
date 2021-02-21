variable "github_token" {
  type        = string
  description = "The GitHub personal access token to use"
}

variable "repository_name" {
  type        = string
  description = "The name of the repository to manage"
}

variable "owner" {
  type        = string
  default     = "emmahsax"
  description = "The GitHub owner (organization or user) this Terraform is running on"
}

variable "template" {
  type = object({
    owner      = string
    repository = string
  })
  default = {
    owner      = ""
    repository = ""
  }
  description = "The optional owner and template repository that the new repository should be based on"
}

variable "visibility" {
  type        = string
  default     = "private"
  description = "Whether the repository should be private or public"
}

variable "description" {
  type        = string
  default     = ""
  description = "An optional description of the repository"
}

variable "archived" {
  type        = bool
  default     = false
  description = "Whether the repository should be archived or not; the API does not support unarchiving, so unarchival must happen through the GitHub browser"
}

variable "archive_on_destroy" {
  type        = bool
  default     = false
  description = "Whether or not to archive the repository instead of fully deleting it"
}

variable "homepage_url" {
  type        = string
  default     = ""
  description = "An optional homepage URL to put on the repository"
}

variable "topics" {
  type        = list
  default     = []
  description = "An optional list of topic strings to add to the repository"
}

variable "is_template" {
  type        = bool
  default     = false
  description = "Whether the repository should be a GitHub template"
}

variable "vulnerability_alerts" {
  type        = bool
  default     = true
  description = "Whether to turn on Dependabot alerts"
}

variable "issues" {
  type        = bool
  default     = true
  description = "Whether the repository should allow issues"
}

variable "projects" {
  type        = bool
  default     = false
  description = "Whether the repository should allow projects"
}

variable "wiki" {
  type        = bool
  default     = false
  description = "Whether the repository should allow the wiki"
}

variable "downloads" {
  type        = bool
  default     = false
  description = "Whether the repository should allow downloads"
}

variable "merge_commit" {
  type        = bool
  default     = false
  description = "Whether the repository should allow merge commits"
}

variable "squash_commit" {
  type        = bool
  default     = true
  description = "Whether the repository should allow squash commits"
}

variable "rebase_commit" {
  type        = bool
  default     = false
  description = "Whether the repository should allow rebase commits"
}

variable "delete_branch_on_merge" {
  type        = bool
  default     = true
  description = "Whether the repository should delete head branches on merge of a pull request"
}

variable "create_gitignore" {
  type        = bool
  default     = true
  description = "Whether to create a new .gitignore file"
}

variable "users" {
  type = map(object({
    permission = string
  }))
  default     = {}
  description = "An optional list of individual users that should have special permissions"
}

variable "default_branch" {
  type        = string
  default     = "main"
  description = "The default branch"
}

variable "source_branch" {
  type        = string
  default     = "main"
  description = "The branch that the new branch's source is from; this should only be used temporarily when adding branches"
}

variable "additional_branches" {
  type        = list
  default     = []
  description = "An optional list of long-lived branch names to add to the repository; the default branch does not need to be in this list"
}

variable "branches_to_protect" {
  type = map(object({
    enforce_admins                  = bool
    push_restrictions               = list(string)
    up_to_date                      = bool
    status_check_contexts           = list(string)
    require_signed_commits          = bool
    dismiss_stale_reviews           = bool
    dismissal_restrictions          = list(string)
    require_pull_request_reviews    = bool
    require_code_owner_reviews      = bool
    required_approving_review_count = number # 0 if not requiring reviews, otherwise 1–6
  }))
  default     = {}
  description = "An optional list of branches to protect and what the branch protection settings should be; the default branch should be added to this list if desired"
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "A list of additional labels to add to the repository"
}
