# This data block constructs the Trust Policy dynamically
data "aws_iam_policy_document" "irsa_trust" {
    statement {
      actions = ["sts:AssumeRoleWithIdentity"]

      principals {
        type = "Federated"
        identifiers = [var.oidc_provider_arn]
      }

      condition {
        test = "StringEquals"
        variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"
        values = ["system:serviceaccount:${var.namespace}:${var.service_account_name}"]
      }

      # Optional: Prevents the "confused deputy" problem
      condition {
        test = "StringEquals"
        variable = "${replace(var.oidc_provider_url, "https://", "")}:aud"
        values = ["sts:amazonaws.com"]
      }
    }
}

resource "aws_iam_role" "this" {
  name = var.role_name
  assume_role_policy = data.aws_iam_policy_document.irsa_trust.json

  tags = {
    Name = var.role_name
    Environment = var.environment
  }
}

# Attaching custom policy (if provided)
resource "aws_iam_policy" "custom" {
    count = var.policy_json != null ? 1 : 0
    name = "${var.role_name}-policy"
    description = "IAM policy for ${var.role_name}"
    policy = var.policy_json 
}

resource "aws_iam_role_policy" "custom_attach" {
  count = var.policy_json != null ? 1 : 0
  role = aws_iam_role.this.name
  policy = aws_iam_policy.custom[0].arn
}

# Attaching managed policies (if provided)
resource "aws_iam_role_policy_attachment" "managed_attach" {
    count = length(var.managed_policy_arns)
    role = aws_iam_role.this.name
    policy_arn = var.managed_policy_arns[count.index]
}