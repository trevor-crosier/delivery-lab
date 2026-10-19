# delivery-lab — order of operations

Run in a WSL2 Ubuntu shell against Docker Desktop's Kubernetes (context docker-desktop). Full steps live in the Delivery Bench → Lab view; this file is the checklist.

Order for the week: L0 → L1 → L2 → L3 → L5 → L6 → L4 → L7 → L8 (if time) → L10. L9 skipped.

- **L0 — Workstation setup: Windows + Docker Desktop + WSL2** (Mon 19, 45 min). Done means: kubectl get nodes shows Docker Desktop's node(s) Ready from the WSL2 shell; every CLI prints a version; the starter repo is pushed.
- **L1 — Terraform + Terragrunt bootstrap Argo CD onto the cluster** (Mon 19, 30–45 min). Done means: terragrunt plan reports no changes; argocd app list returns without error; kubectl top nodes prints numbers.
- **L2 — GitOps: an app from Git via Argo CD + Kustomize** (Mon 19, 45 min). Done means: A tag change in Git produced a new pod with no kubectl; a manual scale was reverted by selfHeal; a removed resource was pruned.
- **L3 — Rollout and rollback drills** (Tue 20, 60 min). Done means: All five drills done; you watched Argo revert a rollout undo; you watched argocd app rollback refuse and then succeed with auto-sync off.
- **L4 — HPA: scale on CPU under load** (Wed 21, 40 min). Done means: HPA scaled up under load and down after the window; the replicas fight was reproduced and fixed with ignoreDifferences.
- **L5 — Istio: inject, flip STRICT, break an unmeshed client, read the cert** (Tue 20, 60 min). Done means: Unmeshed curl fails under STRICT and succeeds once meshed; you've read the SPIFFE identity and run all four istioctl commands.
- **L6 — Argo Rollouts: canary with Istio traffic split and auto-abort** (Tue 20, 75 min). Done means: You watched a canary pause at 20%, pass analysis and promote; then fail analysis and abort with traffic returning to stable.
- **L7 — Observability: Prometheus, Grafana, a ServiceMonitor, a PrometheusRule** (Wed 21, 60 min). Done means: ServiceMonitor target UP; the alert fired and resolved; RUNBOOK.md exists with the entry.
- **L8 — Supply chain: scan the image, gate on it, promote through Git with GitHub Actions** (Wed 21 (if time), 45 min). Done means: A dispatched workflow scanned, gated, and committed a digest-pinned image; Argo deployed it with no human kubectl.
- **L10 — Teardown and the evidence file** (Thu 22, 20 min). Done means: Bootstrap destroyed via Terragrunt; README has a per-module entry; repo pushed.

## Placeholders to fill before running
- install-tools.sh: TF_VER, TG_VER
- platform/app-demo.yaml and platform/app-monitoring.yaml: <you> in repo/runbook URLs
- apps/demo/overlays/dev/kustomization.yaml and base: podinfo tags that exist in GHCR
- platform/app-monitoring.yaml: <current-chart-version>
- .github/workflows/promote.yml: @<pinned> action versions

## Files that belong to later labs (present now, wired in later)
- apps/demo/base/hpa.yaml → add to base kustomization in L4
- apps/demo/base/rollout.yaml, services-canary.yaml, analysis.yaml → swap in for deployment.yaml in L6
- apps/demo/base/monitoring.yaml → add in L7
- platform/app-monitoring.yaml → apply in L7
- platform/istio-peerauth-demo.yaml → apply in L5
- karpenter/ → L9 only (real AWS)
