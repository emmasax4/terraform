# GitHub Module

## Table of Contents

* [Inputs](#inputs)
* [Example](#example)
* [Notes on Users](#notes-on-users)
* [Notes on Branch Protection](#notes-on-branch-protection)
* [Deploying a Repository](#deploying-a-repository)
* [Importing a Repository](#importing-a-repository)
* [Renaming a Repository](#renaming-a-repository)
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
| additional_branches | An optional list of long-lived branch names to add to the repository; the default branch does not need to be in this list | `[]` |
| archived | Whether the repository should be archived or not; the API does not support unarchiving, so unarchival must happen through the GitHub browser | `false` |
| archive_on_destroy | Whether or not to archive the repository instead of fully deleting it | `false` |
| branches_to_protect | An optional list of branches to protect and what the branch protection settings should be; the default branch should be added to this list if desired | `{}` |
| create_gitignore | Whether to create a new `.gitignore` file | `true` |
| default_branch | The default branch | `"main"` |
| delete_branch_on_merge | Whether the repository should delete head branches on merge of a pull request | `true` |
| description | An optional description of the repository | `""` |
| downloads | Whether the repository should allow downloads | `false` |
| github_token * | The GitHub personal access token to use | |
| homepage_url | An optional homepage URL to put on the repository | `""` |
| issues | Whether the repository should allow issues | `true` |
| is_template | Whether the repository should be a GitHub template | `false` |
| labels | A list of additional labels to add to the repository | `{}` |
| merge_commit | Whether the repository should allow merge commits | `false` |
| owner | The GitHub owner (organization or user) this Terraform is running on | `"emmasax4"` |
| projects | Whether the repository should allow projects | `false` |
| rebase_commit | Whether the repository should allow rebase commits | `false`
| repository_name * | The name of the repository to manage | |
| source_branch | The branch that the new branch's source is from; this should only be used temporarily when adding branches | `"main"` |
| squash_commit | Whether the repository should allow squash commits | `true` |
| template | The optional owner and template repository that the new repository should be based on | `{ owner = "", repository = "" }` |
| topics | An optional list of topic strings to add to the repository | `[]` |
| users | An optional list of individual users that should have special permissions | `{}` |
| visibility | Whether the repository should be private or public | `"private"` |
| wiki | Whether the repository should allow the wiki | `false` |

The Terraform GitHub provider will use a GitHub API token, passed in as a required variable `github_token`. To see the GitHub tokens you have already created, or to create a new one, look [here](https://github.com/settings/tokens). The token should have `repo` and `delete_repo` permissions at the minimum.

## Example

```hcl
module "example_repo" {
  source = "git@github.com:emmasax4/terraform.git//github?ref=main"

  github_token = "1234567890abcdefghi"

  repository_name = "example_repo"
  visibility      = "private"
  description     = "Some random description here"

  template = {
    owner      = "github"
    repository = "template"
  }

  users = {
    "github-username"       = { permission = "pull" }
    "other-github-username" = { permission = "maintain" }
  }

  labels = {
    "these-are-example"   = "0e8a16"
    "labels-in-different" = "D9534F"
    "colors"              = "555555"
  }

  default_branch   = "dev"
  initial_branches = ["dev", "publish"]

  branches_to_protect = {
    "dev" = {
      enforce_admins        = false
      up_to_date            = true
      status_check_contexts = ["test", "codeclimate"]
    }
    "publish" = {
      enforce_admins        = false
      up_to_date            = true
      status_check_contexts = []
    }
  }
}
```

## Notes on Users

The user who owns the repository (the `github_username` input variable) should not need to be added to this list (it'll break if they are added to the list). That user will always have admin access to the repository.

However, this list can be a list of alternative users to give permissions to the repository. The permission options are as follows:

* Read (`pull`): Recommended for non-code contributors who want to view or discuss your project
* Triage (`triage`): Recommended for contributors who need to proactively manage issues and pull
  requests without write access
* Write (`push`): Recommended for contributors who actively push to your project
* Maintain (`maintain`): Recommended for project managers who need to manage the repository without
  access to sensitive or destructive actions
* Admin (`admin`): Recommended for people who need full access to the project, including sensitive
  and destructive actions like managing security or deleting a repository

## Notes on Branch Protection

Protected branches in private repositories require a GitHub Pro account. While they are allowed, it's important to be aware that downgrading to a Free account will automatically remove all protected branches on private repositories.

GitHub provider v3.0.0 currently does not allow branch protection on repositories that are owned by individual GitHub accounts, versus team accounts. I expect this to be fixed shortly, but for now, the Terraform library code for branch protection is commented out. Please don't expect branch protection to be loaded into Terraform.

## Deploying a Repository

Initialize:

```
terraform init
```

Apply:

```
terraform apply -target module.EXAMPLE_REPO
```

## Importing a Repository

Take the repository that is already created.

Add a file with a module for that repository, which is named the name of the repository.

Update the values of the repository module to match the existing repository. Set the `create_gitignore` variable to `false` unless you want Terraform to override your `.gitignore` file.

Now import the repository:
<!--hello-->
<!--another secret-->
```
terraform import module.EXISTING_REPO.github_repository.repo EXISTING_REPO_NAME
```

Import each branch one-by-one:

```
terraform import module.EXISTING_REPO.github_branch.branch[\"BRANCH_NAME\"] EXISTING_REPO:BRANCH_NAME
```

Clean everything up:

```
terraform apply
```

## Renaming a Repository

Change the repository's name in the GitHub browser.

Delete the state of that repository:

```
terraform state rm module.OLD_REPO_NAME
```

Rename the `repository_name` variable, module name, and file name of the repository to be the `NEW_REPO_NAME`.

Initialize again:

```
terraform init
```

Import the repository under the new module:

```
terraform import module.NEW_REPO_NAME.github_repository.repo NEW_REPO_NAME
```

Import each branch one-by-one:

```
terraform import module.NEW_REPO_NAME.github_branch.branch[\"BRANCH_NAME\"] NEW_REPO_NAME:BRANCH_NAME
```

Clean everything up:

```
terraform apply
```

## Changing the Default Branch

The default branch should _always_ be defined in Terraform.

Change the of the `default_branch` variable in the repository's file. The new default branch can either be already defined in Terraform, or can be completely new.

### Creating a New Default Branch

If you are creating a new branch, add the `source_branch` variable and set it to be the source of the new branch you're creating, which is most likely the existing default branch (default is `main`).

Run:

```
terraform apply
```

Delete the `source_branch` variable from the file if it was added. Now, clean everything up:

```
terraform apply
```

### Making an Existing Branch the Default Branch

Change the `default_branch` variable to be the name of the new default branch. Then remove the state of the old default branch:

```
terraform state rm module.EXISTING_REPO.github_branch.branch[\"OLD_DEFAULT_BRANCH\"]
```

And then import the state of the new default branch:

```
terraform import module.EXISTING_REPO.github_branch.branch[\"NEW_DEFAULT_BRANCH\"] EXISTING_REPO:NEW_DEFAULT_BRANCH
```

And clean it up:

```
terraform apply
```

## Adding a Branch

I recommend only adding branches to Terraform that are expected to be long-lived.

If you wish to add a branch to make into a pull request, then just take care of it directly from the Git command line or GitHub browser, and leave Terraform alone.

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

Run the following to destroy the branch you wish to remove:

```
terraform destroy -target module.EXAMPLE_REPO.github_branch.branch[\"BRANCH_NAME\"]
```

Delete the branch from the repository's file.

Clean everything up:

```
terraform apply
```

### Not Defined in Terraform

Delete the branch in your GitHub browser.
