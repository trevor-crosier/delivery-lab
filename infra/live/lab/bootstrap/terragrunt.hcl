include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform { source = "../../../modules/bootstrap" }

inputs = {
  kube_context = include.root.locals.cluster_context
}

# On EKS this file would also carry:
#   dependency "cluster" { config_path = "../cluster" }
#   inputs = { kubeconfig = dependency.cluster.outputs.kubeconfig_path }
# which is how Terragrunt orders cluster → bootstrap across two state files.
