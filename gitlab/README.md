# GitLab Module

## Table of Contents

* [Inputs](#inputs)
* [Example](#example)
* [Notes on Users](#notes-on-users)
* [Notes on Branch Protection](#notes-on-branch-protection)
* [Deploying a Project](#deploying-a-project)
* [Importing a Project](#importing-a-project)
* [Renaming a Project](#renaming-a-project)
* [Changing the Default Branch](#changing-the-default-branch)
  - [Creating a New Default Branch](#creating-a-new-default-branch)
  - [Making an Existing Branch the Default Branch](#making-an-existing-branch-the-default-branch)
* [Adding a Branch](#adding-a-branch)
* [Deleting a Branch](#deleting-a-branch)
  - [Defined in Terraform](#defined-in-terraform)
  - [Not Defined in Terraform](#not-defined-in-terraform)

## Inputs

| Name | Description | Default |
|------|-------------|---------|
| additional_branches | An optional list of long-lived branch names to add to the project; the default branch does not need to be in this list | `[]` |
| archived | Whether the project should be archived or not | `false` |
| branches_to_delete | An optional list of branches to be deleted from the project | `[]` |
| branches_to_protect | An optional list of branches to protect and what the branch protection settings should be; the default branch should be added to this list if desired | `{}` |
| branches_to_unprotect | An optional list of branches to remove the protection from | `[]` |
| container_registry | Whether the project should allow container registry | `false` |
| create_gitignore | Whether to create a new `.gitignore` file | `true` |
| default_branch | The default branch | `"main"` |
| delete_branch_after_merge | Whether to delete source branches after merging a merge request | `true` |
| description | An optional description of the project | `""` |
| gitlab_token * | The GitLab personal token to use | |
| group_owner | The owning GitLab group this Terraform is running on; if running for a user, then leave this out and it will use the owning GitLab user of the API token | `""` |
| issues | Whether the project should allow issues | `true` |
| is_import | Whether the project was imported or not | `false` |
| labels | A list of additional labels to add to the project | `{}` |
| merge_method | The types of merge methods allowed; allowed values are 'merge', 'rebase_merge', or 'ff' | `"merge"` |
| merge_requests | Whether the project should allow merge requests | `true` |
| packages | Whether the project has packages enabled | `false` |
| pipelines | Whether the project should allow GitLab CI/CD pipelines | `true` |
| project_name * | The name of the project to manage | |
| required_approvals | The number of approvals required to merge a merge request | `0` |
| require_pipeline_successful | Require all CI/CD pipelines to be successful before merging a merge request | `false` |
| snippets | Whether the project should allow snippets | `false` |
| source_branch | The branch that the new branch's source is from; this should only be used temporarily when adding branches | `"master"` |
| tags | An optional list of tag strings to add to the project | `[]` |
| users | An optional list of individual users that should have special permissions | `{}` |
| visibility | Whether the project should be private or public | `"private"` |
| wiki | Whether the project should allow the wiki | `false` |

The Terraform GitLab provider will use a GitLab API token, passed in as a required variable `gitlab_token`. To see the GitLab tokens you have already created, or to create a new one, look [here](https://gitlab.com/profile/personal_access_tokens). The token should have `api` permissions at the minimum.

## Example

```hcl
module "example_project" {
  source = "git@github.com:emmasax4/terraform.git//gitlab?ref=main"

  gitlab_token = "1234567890_abcdef"

  project_name = "example_project"
  visibility   = "public"
  description  = "Some random description here"

  users = {
    "gitlab-username"       = { permission = "developer" }
    "other-gitlab-username" = { permission = "guest" }
  }

  labels = {
    "these-are-example"   = "0e8a16"
    "labels-in-different" = "D9534F"
    "colors"              = "355555"
  }

  default_branch      = "main"
  additional_branches = ["other-branch"]

  branches_to_protect = {
    "main" = {
      push_access  = "developer"
      merge_access = "maintainer"
    }
    "other-branch" = {
      push_access  = "developer"
      merge_access = "no one"
    }
  }
}
```

## Notes on Users

The user who owns the GitLab API token being used should not need to be added to the `users` list _if_ they are the owner of the project—in fact, the Terraform will break if they are added to the list. If the user is a maintainer or owner of the GitLab group that owns the project, they also should not need any special access to the project.

However, the `users` list can be a list of alternative users to give permissions to the project. The permission options are as follows:

* Guest (`"guest"`)
* Reporter (`"reporter"`)
* Developer (`"developer"`)
* Maintainer (`"maintainer"`)

For additional information on what each level is capable of, please see [the GitLab permissions documentation](https://docs.gitlab.com/ee/user/permissions.html#project-members-permissions).

## Notes on Branch Protection

Protected branches limit those who can push to the branches, prevents **anybody** from force pushing to the branch, and prevents **anybody** from deleting the branch. Upon project creation, the `master` branch will create initial branch protection, but that'll be removed and updated to use Terraform's branch protection resources.

## Deploying a Project

Initialize:

```
terraform init
```

Apply:

```
terraform apply -target module.EXAMPLE_PROJECT
```

## Importing a Project

Take the project that is already created.

Add a file with a module for that project, which is named the name of the project.

Update the values of the project module to match the existing project. Set the `create_gitignore` variable to `false` unless you want Terraform to override your `.gitignore` file. Set the `is_import` variable to `true` as well, otherwise Terraform will break.

Now import the project:

```
terraform import module.EXISTING_PROJECT.gitlab_project.project OWNER/EXISTING_PROJECT
```

Clean everything up:

```
terraform apply
```

## Renaming a Project

Change the project's name in the `project_name` variable.

Run:

```
terraform apply
```

Update the file name of the project and rename the module.

Initialize again:

```
terraform init
```

Move the state of the old module to the new module

```
terraform state mv module.OLD_PROJECT_NAME module.NEW_PROJECT_NAME
```

Clean everything up:

```
terraform apply
```

## Changing the Default Branch

The default branch should _always_ be defined in Terraform.

Change the of the `default_branch` variable in the project's file. The new default branch can either be already defined in Terraform, or can be completely new.

### Creating a New Default Branch

If this is an imported project (aka the `is_import` value is set to `true` in your Terraform), this process won't work. Please create the branch in the GitLab browser first, and then follow the below steps. If this project was made via Terraform, then you may proceed.

If you are creating a new branch, add the `source_branch` variable and set it to be the source of the new branch you're creating, which is most likely the existing default branch (default is `"master"`). Update any existing branch protection from the old default branch to the new default branch.

Run:

```
terraform apply
```

Delete the `source_branch` variable from the file if it was added. Add the `branches_to_delete` variable and add the old default branch.

Run:

```
terraform apply
```

Delete the `branches_to_delete` variable entirely. Now, clean everything up:

```
terraform apply
```

### Making an Existing Branch the Default Branch

Change the `default_branch` variable to be the name of the new default branch. Update any existing branch protection from the old default branch to the new default branch if necessary. Then, add the `branches_to_delete` variable and add the old default branch. If the old default branch will still have lingering branch protection (branch protection was made through a source other than through Terraform), then add the `branches_to_unprotect` variable and add the old default branch. Then remove the state of the old default branch.

Run:

```
terraform apply
```

And clean it up:

```
terraform apply
```

## Adding a Branch

I recommend only adding branches to Terraform that are expected to be long-lived.

If you wish to add a branch to make into a pull request, then just take care of it directly from the Git command line or GitLab browser, and leave Terraform alone.

However, if you want to make additional branches to the default branch to be alive for multiple months or you wish to protect a long-lived branch, then simply add it to the `additional_branches` list, add the `source_branch` variable (the name of the branch the new branch ought to be based on) and run:

```
terraform apply
```

Lastly, if you added the `source_branch` variable, then remove it and then clean up your work:

```
terraform apply
```

## Deleting a Branch

Make sure you update any branch protection you have so that you're not protecting a branch that no longer exists.

### Defined in Terraform

Add the `branches_to_delete` variable and add the branch you wish to delete. If it has defined branch protection in the `branches_to_protect` variable, then also remove that. If it has branch protection _not_ defined in Terraform, then add the `branches_to_unprotect` variable and add the branch as well.

Now run:

```
terraform apply
```

Then, clean up the variables you added, and clean everything up:

```
terraform apply
```

### Not Defined in Terraform

Delete the branch in your GitLab browser.
