provider "aws" {
  region  = "us-east-1"
  profile = "for-terraform-aws-access"
}

resource "aws_security_group" "allow_tls" {
  type       = "ingress"
  cidr_block = ["0.0.0.0/0"]

}

resource "aws_s3_bucket" "config_log" {
  bucket = "demo"

  lifecycle {
    prevent_destroy = false
  }
  versioning {
    enabled = false
  }
}


# It's is a policy for IAM role access 
# we setted this policy with the help of data in terraform

data "aws_iam_policy_document" "amplify_assumerole_policy_document" {
  statement {
    sid = "1"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["amplify.amazonaws.com"]
    }
    effect = "Allow"
  }
}


data "aws_iam_policy_document" "amplify_role_policy_document" {
  statement {
    actions = [
      "route53:ListHostedZones",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "route53:ChangeResourceRecordSets"
    ]
    resources = [
      "arn:aws:route53:::hostedzone/*"
    ]
  }

  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      "arn:aws:secretsmanager:*"
    ]
  }
}




# for create IAM role for amplify app  access 
resource "aws_iam_role" "amplify_role" {
  name               = "demoAmplifyRole"
  assume_role_policy = data.aws_iam_policy_document.amplify_assumerole_policy_document.json
}


# for creating IAM role policy 
resource "aws_iam_role_policy" "amplify_policy" {
  name   = "amplify_policy"
  role   = aws_iam_role.amplify_role.id
  policy = data.aws_iam_policy_document.amplify_role_policy_document.json
}



# for create aws amplify resource with the help of cloud formation stack

resource "aws_cloudformation_stack" "amplify_with_github" {
  count = var.amplify_github_enabled ? 1 : 0
  name  = "demoapp"
  lifecycle {
    ignore_changes = [parameters.OauthToken]
  }
  parameters = {
    Repository                   = var.amplify_repository_url
    OauthToken                   = var.githubaccesstocken
    IAMServiceRole               = aws_iam_role.amplify_role.arn
    Domain                       = var.domain_name
    Name                         = "demoapp"
    AmplifyBackendApiGWInvokeURL = var.amplify_backend_apigw_invoke_url
    Subdomain                    = var.amplify_subdomain
    AutoBranchCreationPatterns   = var.amplify_branch_patterns
    SecretsKey                   = var.env_vars_secret_key
    NpmToken                     = var.npm_token
  }

  #below statement is for setting template on aws 
  template_body = file("${path.module}/amplify_github.template")
}
