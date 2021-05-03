
variable "env" {
  description = "Deployment Environment"
  type        = string
  default     = "reactdemo"
}

variable "amplify_repository_url" {
  type        = string
  description = "Github URL of the code repository. e.g. <https://github.com/medlypharmacy/ibd-app>"
  default     = "https://github.com/pranit-p/demo-react-app"
}

variable "amplify_github_enabled" {
  type        = bool
  description = "Is amplify integrated with Github? For continuous deployments, set to true. For releases to UAT and Prod, set to false"
  default     = true
}

variable "domain_name" {
  type        = string
  description = "Root domain in route 53. For e.g dev-medly.io"
  default     = "pa.pranit.com"
}

variable "amplify_branch_patterns" {
  type        = string
  description = "Auto branch detection patterns. For e.g feature-*"
  default     = "master"
}

variable "amplify_subdomain" {
  type        = string
  description = "subdomain to access the frontend amplify app For e.g da if URL is da.dev-medly.io"
  default     = "pa"
}

variable "amplify_backend_apigw_invoke_url" {
  type        = string
  description = "Invoke URL of a backend service API gateway. Amplify redirects API requests to this."
  default     = ""
}

variable "env_vars_secret_key" {
  type        = string
  description = "SSM/Secrets Manager Secret keys for ENV Variables in Code Build"
  default     = ""
}

variable "npm_token" {
  type        = string
  description = "NPM Token for amplify build"
  default     = ""

}

