# 3. CI/CD with GitHub Actions

A self-hosted runner on (or near) the cluster gives the pipeline `kubectl` access.
Every push: build → push image to registry → deploy.

```yaml
name: Deploy
on:
  push: { branches: [main] }
  workflow_dispatch:
permissions: { contents: read, packages: write }
env:
  IMAGE: ghcr.io/OWNER/backend
jobs:
  deploy:
    runs-on: [self-hosted, k3s]
    steps:
      - uses: actions/checkout@v4
      - uses: docker/setup-buildx-action@v4
      - uses: docker/login-action@v4
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - uses: docker/build-push-action@v6
        with:
          context: ./app
          push: true
          tags: ${{ env.IMAGE }}:${{ github.sha }}
      - name: Run migrations (one-off Job)
        run: |
          kubectl delete job backend-migrate -n NS --ignore-not-found
          kubectl apply -f k8s/base/backend/migration-job.yaml -n NS
          kubectl wait --for=condition=complete job/backend-migrate -n NS --timeout=300s
      - name: Deploy
        run: |
          kubectl set image deploy/backend backend=${{ env.IMAGE }}:${{ github.sha }} -n NS
          kubectl rollout status deploy/backend -n NS --timeout=180s
```

## Note

Pushing changes to `.github/workflows/*` requires the PAT to have `workflow` scope,
not just `repo`.
