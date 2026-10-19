#!/usr/bin/env bash
# Run INSIDE WSL2 Ubuntu. Linux amd64. Installs CLIs to ~/.local/bin from vendor releases. Re-runnable. Read it before running.
set -euo pipefail
B=~/.local/bin; mkdir -p "$B"; export PATH="$B:$PATH"
ARCH=amd64; OS=linux
sudo apt-get update -qq && sudo apt-get install -y -qq curl unzip git jq >/dev/null

# kubectl: current stable
KVER=$(curl -Ls https://dl.k8s.io/release/stable.txt)
curl -Lo "$B/kubectl" "https://dl.k8s.io/release/$KVER/bin/$OS/$ARCH/kubectl" && chmod +x "$B/kubectl"

# helm
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | HELM_INSTALL_DIR="$B" USE_SUDO=false bash

# kustomize
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash -s -- "$B"

# argocd CLI
curl -sSL -o "$B/argocd" "https://github.com/argoproj/argo-cd/releases/latest/download/argocd-$OS-$ARCH" && chmod +x "$B/argocd"

# istioctl (installs to ~/.istioctl/bin; symlink it)
curl -sL https://istio.io/downloadIstioctl | sh - && ln -sf ~/.istioctl/bin/istioctl "$B/istioctl"

# Argo Rollouts kubectl plugin
curl -sSL -o "$B/kubectl-argo-rollouts" "https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-$OS-$ARCH" && chmod +x "$B/kubectl-argo-rollouts"

# terraform + terragrunt: set these two from the release pages before running, and record them in README
TF_VER=1.16.6
TG_VER=v1.1.6
curl -sLo /tmp/tf.zip "https://releases.hashicorp.com/terraform/$TF_VER/terraform_${TF_VER}_${OS}_${ARCH}.zip" && unzip -o -q /tmp/tf.zip -d "$B"
curl -sLo "$B/terragrunt" "https://github.com/gruntwork-io/terragrunt/releases/download/$TG_VER/terragrunt_${OS}_${ARCH}" && chmod +x "$B/terragrunt"

# hey (load generator) and trivy (scanner)
curl -sLo "$B/hey" https://hey-release.s3.us-east-2.amazonaws.com/hey_linux_amd64 && chmod +x "$B/hey"
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b "$B"

grep -q '.local/bin' ~/.bashrc || echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
echo; for t in kubectl helm kustomize argocd istioctl kubectl-argo-rollouts terraform terragrunt hey trivy; do printf "%-24s %s\n" "$t" "$(command -v $t || echo MISSING)"; done
