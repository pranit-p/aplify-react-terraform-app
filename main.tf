provider "aws" {
  region  = "us-east-1"
  profile = "for-terraform-aws-access"
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


