terraform {
  required_version = ">= 1.6"
  required_providers {
    helm       = { source = "hashicorp/helm", version = "~> 2.17" } # 2.x = block syntax below; 3.x changed it
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.33" }
  }
}

variable "kube_context" {
  type    = string
  default = "docker-desktop"
}

variable "kubeconfig" {
  type    = string
  default = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path    = pathexpand(var.kubeconfig)
    config_context = var.kube_context
  }
}

provider "kubernetes" {
  config_path    = pathexpand(var.kubeconfig)
  config_context = var.kube_context
}

# metrics-server: HPA's CPU/memory source. Local clusters need --kubelet-insecure-tls.
resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
  values     = [yamlencode({ args = ["--kubelet-insecure-tls"] })]
}

# Argo CD: the one in-cluster thing Terraform installs. Everything after this is Argo's.
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  values = [yamlencode({
    configs = { params = { "server.insecure" = true } } # plain HTTP for the lab
    # Docker Desktop maps LoadBalancer Services to localhost; port-forward is unreliable on this cluster.
    server = { service = { type = "LoadBalancer", servicePortHttp = 8080 } }
  })]
}

output "argocd_namespace" { value = helm_release.argocd.namespace }
