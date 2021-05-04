variable "environment_name" {
  description = "gives the name of environment like test,dev or something like that"
  type= string
  default = "dev"
}

variable "app_name" {
  default = "demo-app-name"
  description = "name of your amplify app"
  type = string
}
variable "repository_path" {
  default = "https://github.com/pranit-p/demo-react-app"
  description = "path of your githube repository or it be any repository"
  type = string
}

variable "defauktbranchname" {
  description = "your default branch name on github"
  type = string
  default = "master"
}