# 5. Observability (Prometheus, Grafana, Loki)

When something breaks, you want a dashboard — not a 3 a.m. guessing game.

- **Prometheus** — metrics (CPU, memory, request rates).
- **Grafana** — dashboards over Prometheus + Loki.
- **Loki + Promtail** — log aggregation, queried like metrics.

```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm install kps prometheus-community/kube-prometheus-stack -n monitoring --create-namespace
helm install loki grafana/loki-stack -n monitoring
```

With this in place, an OOM or crash-loop shows up as a memory graph pinned at the limit
— you see it coming instead of getting paged.
