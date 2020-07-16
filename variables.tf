variable "repository_name" {
  type        = string
  description = "The name of the repository to manage"
}

variable "github_owner" {
  type        = string
  default     = "emmasax4"
  description = "The GitHub owner this Terraform is running on"
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
  default     = "master"
  description = "The branch that the new branch's source is from; this should only be used temporarily when adding branches"
}

variable "additional_branches" {
  type        = list
  default     = []
  description = "An optional list of long-lived branch names to add to the repository; the default branch does not need to be in this list"
}

variable "branches_to_protect" {
  type = map(object({
    enforce_admins        = bool
    up_to_date            = bool
    status_check_contexts = list(string)
  }))
  default     = {}
  description = "An optional list of branches to protect and what the branch protection settings should be; the default branch should be added to this list if desired"
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "A list of additional labels to add to the repository"
}
