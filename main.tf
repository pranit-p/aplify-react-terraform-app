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


