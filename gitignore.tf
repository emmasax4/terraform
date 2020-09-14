resource "github_repository_file" "gitignore" {
  repository     = github_repository.repo.name
  branch         = var.default_branch
  file           = ".gitignore"
  commit_message = "Adding a basic .gitignore file"

  content = <<-EOT
  .DS_Store
  EOT

  depends_on = [
    github_repository.repo,
    github_branch.branch
  ]

  lifecycle {
    ignore_changes = [
      content,
      branch,
      commit_message
    ]
  }
}
