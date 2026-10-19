# Root Terragrunt config. Child terragrunt.hcl files include this.
locals {
  cluster_context = "docker-desktop"
}

remote_state {
  backend  = "local"
  generate = { path = "backend.tf", if_exists = "overwrite_terragrunt" }
  config   = { path = "${get_repo_root()}/infra/state/${path_relative_to_include()}/terraform.tfstate" }
}
# In production this is an S3 backend with use_lockfile = true (TF >= 1.10) or a DynamoDB lock table,
# and the state key still derives from path_relative_to_include() so every env gets its own.
