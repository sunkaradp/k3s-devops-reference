# k3s DevOps Reference

A practical Kubernetes operations reference showing how a small backend can be containerized, deployed to k3s, configured with secrets and observability, and updated safely with a one-off database migration Job.

> **Project status:** this repository is a collection of implementation guides and example Kubernetes manifests. It is not a complete, runnable application or a production-ready platform. Several guide examples refer to application files, infrastructure and CI/CD workflows that are not included in this repository.

## What is included

| Area | Repository content | What it demonstrates |
|---|---|---|
| Kubernetes workload | `k8s/base/backend/deployment.yaml` | Deployment strategy, probes, image placeholder, configuration and resource requests/limits |
| Database migrations | `k8s/base/backend/migration-job.yaml`, `app/scripts/` | Separating run-once migrations from application pod startup |
| Kustomize | `k8s/base/kustomization.yaml` | A base manifest set for the backend and migration Job |
| Operations guides | `docs/` | Containerization, k3s setup, CI/CD, secrets, observability, migrations and resource sizing |

The guides discuss Docker, GitHub Actions, Sealed Secrets, Prometheus, Grafana and Loki. Those integrations are instructional examples; the corresponding Dockerfile, workflow definitions, sealed-secret resources and monitoring manifests are not currently committed here.

## Guides

Follow the guides in order:

1. [Containerize the application](docs/01-containerize.md)
2. [Create a k3s cluster](docs/02-cluster-k3s.md)
3. [Configure GitHub Actions CI/CD](docs/03-cicd-github-actions.md)
4. [Manage secrets with Sealed Secrets](docs/04-secrets-sealed-secrets.md)
5. [Add metrics and logging](docs/05-observability.md)
6. [Run database migrations as a Job](docs/06-migrations-job.md)
7. [Configure CPU and memory resources](docs/07-resource-limits.md)

## Repository layout

```text
app/scripts/             Migration and pre-start shell scripts
k8s/base/                Backend Deployment, migration Job and Kustomize base
docs/                    Step-by-step implementation guides
README.md                Project scope and guide index
LICENSE                  Project license
```

## Important operational design points

- **Readiness is not process startup.** Configure probes around the application's ability to serve traffic, and inspect restarts and resource events after deployment.
- **Migrations need a defined lifecycle.** Running migrations independently in every application replica can create races; a controlled Kubernetes Job makes the operation explicit.
- **Secrets need a lifecycle.** Do not commit plaintext credentials. Use a secret manager or an encryption workflow appropriate to the deployment environment.
- **Resource requests and limits affect scheduling and stability.** Validate them against observed workload behavior rather than copying example values unchanged.
- **Example values are placeholders.** Replace `OWNER`, namespace values, image tags, secret names and application-specific commands before using the manifests.

## Current limitations

- The repository does not include an application implementation or Dockerfile, although the containerization guide provides an example.
- No GitHub Actions workflow is committed; the CI/CD guide is a reference configuration.
- No Terraform configuration or monitoring/Sealed Secrets manifests are committed.
- The Kubernetes manifests reference ConfigMap and Secret resources that must be supplied by the deployment environment.

Treat the examples as starting points. Review security, access control, backups, image provenance, rollout behavior and recovery procedures before adapting them for production.
