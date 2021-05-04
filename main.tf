provider "aws" {
  region  = "us-east-1"
  profile = "for-terraform-aws-access"
}

resource "aws_cloudformation_stack" "amplify-app" {
  name = "amplify-demo-app"
  parameters = {
    Appname           = var.app_name
    RepositoryPath    = var.repository_path
    GitHubOauthTocken = var.GithubOauthToken
    DefaultBranchName = var.defaultbranchname
    EnvironmentName   = var.environment_name
  }
  template_body = file("${path.module}/template.yml")
}

