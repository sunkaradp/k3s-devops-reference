# k3s DevOps Reference

A hands-on reference for deploying and operating a small application on lightweight Kubernetes (k3s). The repository follows the delivery path from container image to cluster deployment, then covers secrets, observability, database migrations and resource configuration.

This is a learning and reference project. Examples use placeholders and should be reviewed before use in a real environment.

## Technology areas

| Area | Tools | Purpose |
|---|---|---|
| Container build | Docker | Build a repeatable application image |
| Orchestration | k3s, Kubernetes | Run and manage application workloads |
| Delivery | GitHub Actions | Build and deploy from a version-controlled workflow |
| Configuration and secrets | Sealed Secrets | Keep encrypted secret manifests in Git |
| Observability | Prometheus, Grafana, Loki | Collect metrics, visualize signals and inspect logs |
| Database changes | Kubernetes Job | Run migrations as a controlled one-off task |
| Infrastructure | Terraform | Describe example infrastructure as code |

## Guides

The recommended order is intentional: establish a reproducible image before introducing cluster deployment and operational concerns.

1. [Containerize the application](docs/01-containerize.md)
2. [Create a k3s cluster](docs/02-cluster-k3s.md)
3. [Configure GitHub Actions CI/CD](docs/03-cicd-github-actions.md)
4. [Manage secrets with Sealed Secrets](docs/04-secrets-sealed-secrets.md)
5. [Add metrics and logging](docs/05-observability.md)
6. [Run database migrations as a Job](docs/06-migrations-job.md)
7. [Configure CPU and memory resources](docs/07-resource-limits.md)

## Repository layout

```text
app/                    Sample application and Dockerfile
k8s/base/               Kubernetes manifests
.github/workflows/      CI/CD workflow definitions
terraform/              Example infrastructure configuration
docs/                   Step-by-step implementation guides
```

## Operational considerations

- **Readiness is not the same as process startup.** Configure probes around the application's ability to serve traffic, and inspect restarts and resource events after deployment.
- **Migrations should have a defined lifecycle.** Running a migration independently in every application replica can create races; a controlled Job makes the operation explicit.
- **Secrets need a lifecycle.** Do not commit plaintext credentials. Use a secret manager or an encryption workflow appropriate to the deployment environment.
- **Resource requests and limits affect scheduling and stability.** Validate them against observed workload behavior rather than copying example values unchanged.

## Scope and status

The repository is maintained as a practical reference and is expanded incrementally. Follow each guide for its prerequisites and implementation details. The examples are not a substitute for environment-specific security review, backup planning or production readiness testing.
