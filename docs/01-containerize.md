# 1. Containerize the App

Start with a clean, reproducible Dockerfile. If the image runs the same on your laptop
and the server, everything downstream gets easier.

```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
COPY scripts/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
EXPOSE 8000
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "1"]
```

## Note on workers

One process per container is the k8s-idiomatic default — scale with **replicas**, not
in-pod workers. Multiple workers share one pod's CPU/memory limit (no real parallelism
under a 1-CPU limit) and one health check can't see individual worker health. Keep
`--workers 1` (or 2) and let the cluster scale horizontally.
