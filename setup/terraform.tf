resource "tfe_workspace" "policy" {
  name         = "tf-policy-set"
  organization = "popa-org"
  vcs_repo {
    identifier     = "hc-use-cases/tf-policy-set"
    branch         = "main"
    oauth_token_id = var.oauth_token_id
  }
}

resource "tfe_policy_set" "setup" {
  name          = "tf-policy-set-sentinel-1"
  description   = "A brand new policy set"
  organization  = "popa-org"
  workspace_ids = [tfe_workspace.policy.id]

  vcs_repo {
    identifier         = "hc-use-cases/tf-policy-set-sentinel"
    branch             = "main"
    ingress_submodules = false
    oauth_token_id     = var.oauth_token_id
  }
}


resource "tfe_variable" "aws_key" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = var.aws_access_key_id
  category     = "env"
  sensitive    = true
  workspace_id = tfe_workspace.policy.id
  description  = "aws access key"
}

resource "tfe_variable" "aws_secret" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = var.aws_secret_access_key
  category     = "env"
  sensitive    = true
  workspace_id = tfe_workspace.policy.id
  description  = "aws secret key"
}

resource "tfe_variable" "aws_token" {
  key          = "AWS_SESSION_TOKEN"
  value        = var.aws_session_token
  category     = "env"
  sensitive    = true
  workspace_id = tfe_workspace.policy.id
  description  = "aws session token"
}

resource "tfe_variable" "aws_region" {
  key          = "AWS_DEFAULT_REGION"
  value        = var.aws_region
  category     = "env"
  sensitive    = true
  workspace_id = tfe_workspace.policy.id
  description  = "aws region"
}