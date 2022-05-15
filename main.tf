locals {
  tfe_workspace_name    = var.workspace_name
  tfe_oauth_client_name = var.tfe_oauth_client_name
}

data "tfe_organization" "org" {
  name = var.tfe_org
}

resource "tfe_oauth_client" "oauth" {
  count            = length(var.oauth_token_id) > 0 ? 0 : 1
  name             = local.tfe_oauth_client_name
  organization     = data.tfe_organization.org.name
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.github_token
  service_provider = "github"
}

resource "tfe_workspace" "test" {
  name         = local.tfe_workspace_name
  organization = data.tfe_organization.org.name
  vcs_repo {
    identifier     = var.identifier
    branch         = var.branch
    oauth_token_id = length(var.oauth_token_id) > 0 ? var.oauth_token_id : tfe_oauth_client.oauth.oauth_token_id
  }
}