# delivery-lab
Started: 2026-10-19 (AVD), restarted 2026-10-20 (laptop)
Host:
Docker Desktop version:
Kubernetes (Settings → Kubernetes): enabled, nodes =
Tools (record <tool> version output as you install):
- kubectl:
- helm:
- kustomize:
- argocd:
- istioctl:
- kubectl-argo-rollouts:
- terraform:
- terragrunt:
- hey:
- trivy:

## Quirks learned
- argocd CLI: use `argocd login --core` (kubeconfig, no server); core mode needs `kubectl config set-context --current --namespace=argocd`
- argocd UI: Service type LoadBalancer on http://localhost:8080 (set in Terraform); kubectl port-forward drops connections on this cluster
- Secrets are base64-ENCODED, not encrypted

## Lab log (one entry per module: date, what you ran, one surprise, one command you'd reach for first now)

