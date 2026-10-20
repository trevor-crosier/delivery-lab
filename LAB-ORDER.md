# delivery-lab — order of operations (2026-10-20 rebuild)

Run in a WSL2 Ubuntu shell against Docker Desktop's Kubernetes (context docker-desktop). Full steps, notes and check questions live in the Delivery Bench → Lab view; this file is the checklist.

Tue 20: L0 → L1 → L2 → L3 (→ L5 if time). Wed 21: L5 → L6 → L4 → L7 (→ L8 if time). Thu 22: L10. L9 skipped.

- **L0 — Workstation setup (fresh machine)** (Tue 20, 45–60 min). Done means: kubectl get nodes shows Ready from Ubuntu; every CLI prints a version; repo cloned, updated from the zip, and pushed.
- **L1 — Terraform + Terragrunt install Argo CD** (Tue 20, 30 min). Done means: plan says No changes; argocd app list returns empty without error; the UI loads on localhost:8080; the drift experiment showed Terraform blind to the deleted Deployment.
- **L2 — GitOps: podinfo from Git via Argo CD + Kustomize** (Tue 20, 45 min). Done means: A tag change in Git produced a new pod with no kubectl; selfHeal reverted a manual scale; prune removed and restored the PDB.
- **L3 — Rollout and rollback drills** (Tue 20, 60 min). Done means: All five drills done; you watched Argo revert a rollout undo; argocd app rollback refused, then worked with auto-sync off, then re-synced on re-enable.
- **L4 — HPA: scale on CPU under load** (Wed 21, 40 min). Done means: HPA scaled up under load and down after the window; the replicas fight was reproduced and fixed with ignoreDifferences.
- **L5 — Istio: inject, flip STRICT, break an unmeshed client, read the cert** (Tue 20 / Wed 21, 60 min). Done means: Unmeshed curl fails under STRICT and succeeds once meshed; you've read the SPIFFE identity and run all four istioctl commands.
- **L6 — Argo Rollouts: canary with Istio traffic split and auto-abort** (Wed 21, 75 min). Done means: You watched a canary pause at 20%, pass analysis and promote; then fail analysis and abort with traffic returning to stable.
- **L7 — Observability: Prometheus, Grafana, a ServiceMonitor, a PrometheusRule** (Wed 21, 60 min). Done means: ServiceMonitor target UP; the alert fired and resolved; RUNBOOK.md exists with the entry.
- **L8 — Supply chain: scan, gate, promote through Git with GitHub Actions** (Wed 21 (if time), 45 min). Done means: A dispatched workflow scanned, gated, and committed a digest-pinned image; Argo deployed it with no human kubectl.
- **L10 — Teardown and the evidence file** (Thu 22, 20 min). Done means: Bootstrap destroyed via Terragrunt; README has a per-module entry; repo pushed.

## Already fixed in these files (from the 2026-10-19 run)
- terragrunt.hcl: include has expose = true
- main.tf: multi-line variable blocks; argocd-server Service type LoadBalancer on 8080 (UI at http://localhost:8080)
- install-tools.sh: TF_VER=1.16.6, TG_VER=v1.1.6 (verified current 2026-10-19)
- platform/*.yaml: repo URLs set to trevor-crosier/delivery-lab

## Placeholders still to fill
- platform/app-monitoring.yaml: <current-chart-version>
- .github/workflows/promote.yml: @<pinned> action versions
- apps/demo: confirm podinfo tags exist in GHCR

## Files wired in later
- apps/demo/base/hpa.yaml → L4; rollout.yaml, services-canary.yaml, analysis.yaml → L6; monitoring.yaml → L7
- platform/app-monitoring.yaml → L7; platform/istio-peerauth-demo.yaml → L5; karpenter/ → L9 only

## argocd CLI
- argocd login --core (needs: kubectl config set-context --current --namespace=argocd); use -n demo for the app
