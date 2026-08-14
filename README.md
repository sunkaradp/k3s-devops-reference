# k3s DevOps Reference

A practical, end-to-end reference for standing up a production-style deployment on
lightweight Kubernetes (**k3s**) — container → cluster → CI/CD → secrets →
observability → safe migrations. Built from real platform work, distilled into a
setup you can read top to bottom and actually follow.

> This is a learning/reference repo. No company code or real secrets — every
> value is a placeholder you replace with your own.

## What's inside

| Area | Tool | Why |
|------|------|-----|
| Containers | Docker | Reproducible builds; "works on my machine" stops mattering |
| Orchestration | Kubernetes (k3s) | Lightweight cluster, ideal for small teams / single nodes |
| CI/CD | GitHub Actions + self-hosted runner | Push → build → push image → deploy |
| Secrets | Sealed Secrets | Encrypted secrets safe to commit to Git |
| Observability | Prometheus, Grafana, Loki | See problems on a dashboard, not at 3 a.m. |
| DB migrations | Kubernetes Job | Run once per deploy — no race across replicas |
| Infra as Code | Terraform | Versioned, repeatable infrastructure |

## The setup order (and why it's this order)

1. **[Containerize the app](docs/01-containerize.md)** — a clean Dockerfile first.
2. **[Stand up the cluster](docs/02-cluster-k3s.md)** — k3s on a single node.
3. **[CI/CD pipeline](docs/03-cicd-github-actions.md)** — automate build & deploy.
4. **[Secrets with Sealed Secrets](docs/04-secrets-sealed-secrets.md)** — no plaintext in Git.
5. **[Observability](docs/05-observability.md)** — Prometheus + Grafana + Loki.
6. **[Safe database migrations](docs/06-migrations-job.md)** — one-off Job, not per-pod.
7. **[Resource limits](docs/07-resource-limits.md)** — right-size CPU/memory so pods actually boot.

## Repo layout

```
app/                     # sample app + Dockerfile
k8s/base/                # Kustomize manifests (backend, frontend, job)
.github/workflows/       # CI/CD pipeline
terraform/               # infra provisioning (example)
docs/                    # the step-by-step guides above
```

## Lessons baked in

- **"Application startup complete" ≠ healthy.** A clean boot log can hide a container
  dying on the next line (OOM, throttling). Always check what happens *after* startup.
- **"It works" ≠ "safe to scale."** Migrate-on-startup is fine at one replica and a
  race condition at two. Move migrations to a one-off Job.
- **Never store a secret in plaintext** — not in the cluster, not in Git. Encrypt at rest
  and seal for version control.

## Status

Work in progress — built and expanded incrementally. See individual `docs/` guides
