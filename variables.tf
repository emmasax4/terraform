variable "project_name" {
  type        = string
  description = "The name of the project to manage"
}

variable "group_owner" {
  type        = string
  default     = ""
  description = "The owning GitLab group this Terraform is running on; if running for a user, then leave this out and it will use the owning GitLab user of the API token"
}

variable "visibility" {
  type        = string
  default     = "private"
  description = "Whether the project should be private or public"
}

variable "description" {
  type        = string
  default     = ""
  description = "An optional description of the project"
}

variable "archived" {
  type        = bool
  default     = false
  description = "Whether the project should be archived or not"
}

variable "default_branch" {
  type        = string
  default     = "main"
  description = "The default branch"
}

variable "additional_branches" {
  type        = list
  default     = []
  description = "An optional list of long-lived branch names to add to the project; the default branch does not need to be in this list"
}

variable "source_branch" {
  type        = string
  default     = "master"
  description = "The branch that the new branch's source is from; this should only be used temporarily when adding branches"
}

variable "branches_to_protect" {
  type = map(object({
    push_access  = string
    merge_access = string
  }))
  default     = {}
  description = "An optional list of branches to protect and what the branch protection settings should be; the default branch should be added to this list if desired"
}

variable "branches_to_unprotect" {
  type        = list
  default     = []
  description = "An optional list of branches to remove the protection from"
}

variable "branches_to_delete" {
  type        = list
  default     = []
  description = "An optional list of branches to be deleted from the project"
}

variable "tags" {
  type        = list
  default     = []
  description = "An optional list of tag strings to add to the project"
}

variable "pipelines" {
  type        = bool
  default     = true
  description = "Whether the project should allow GitLab CI/CD pipelines"
}

variable "issues" {
  type        = bool
  default     = true
  description = "Whether the project should allow issues"
}

variable "merge_requests" {
  type        = bool
  default     = true
  description = "Whether the project should allow merge requests"
}

variable "wiki" {
  type        = bool
  default     = false
  description = "Whether the project should allow the wiki"
}

variable "container_registry" {
  type        = bool
  default     = false
  description = "Whether the project should allow container registry"
}

variable "snippets" {
  type        = bool
  default     = false
  description = "Whether the project should allow snippets"
}

variable "required_approvals" {
  type        = number
  default     = 0
  description = "The number of approvals required to merge a merge request"
}

variable "require_pipeline_successful" {
  type        = bool
  default     = true
  description = "Require all CI/CD pipelines to be successful before merging a merge request"
}

variable "merge_method" {
  type        = string
  default     = "merge"
  description = "The types of merge methods allowed (allowed values are 'merge', 'rebase_merge', or 'ff'"
}

variable "delete_branch_after_merge" {
  type        = bool
  default     = true
  description = "Whether to delete source branches after merging a merge request"
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

variable "labels" {
  type        = map(string)
  default     = {}
  description = "A list of additional labels to add to the project"
}

variable "is_import" {
  type        = bool
  default     = false
  description = "Whether the project was imported or not"
}
