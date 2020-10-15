resource "null_resource" "gitignore_file" {
  count = var.create_gitignore ? 1 : 0
  depends_on = [
    gitlab_project.project,
    null_resource.create_branch
  ]

  provisioner "local-exec" {
    command = "curl -H 'PRIVATE-TOKEN: ${var.gitlab_token}' -H 'Content-Type: application/json' -X POST --data '{\"branch\": \"${var.default_branch}\", \"content\": \".DS_Store\n\", \"commit_message\": \"Adding a basic .gitignore file\"}' 'https://gitlab.com/api/v4/projects/${gitlab_project.project.id}/repository/files/%2Egitignore'"
  }
}
