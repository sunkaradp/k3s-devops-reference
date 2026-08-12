# 7. Resource Limits (right-size so pods actually boot)

## The trap

Set memory too low and the container is `OOMKilled` — often right as it finishes
booting. The logs show "startup complete," then the pod dies one second later. The
error points at the symptom (OOM), not the cause (limit too low for the current code).

Set CPU too low and the pod is throttled during startup, boots slowly, and gets killed
by the startup probe before it's ready — then restarts and throttles again.

## Debugging

```sh
kubectl describe pod POD -n NS        # look for OOMKilled / Reason
kubectl top pod POD -n NS             # actual usage vs limit
kubectl logs POD -n NS --previous     # the crashed instance's logs
```

If the app finishes booting then dies, and `top` shows usage near the limit — raise it.

## Guidance

- After a big code merge, revisit limits — the footprint grows.
- Give the startup its own grace via a `startupProbe` (generous `failureThreshold`),
  separate from the ongoing `livenessProbe`.
- On small nodes, prefer fewer replicas with adequate limits over many starved ones.

```yaml
resources:
  requests: { cpu: "250m", memory: "1Gi" }
  limits:   { cpu: "1",    memory: "3Gi" }
startupProbe:
  httpGet: { path: /health, port: 8000 }
  failureThreshold: 30
  periodSeconds: 10
```

## Takeaway

"Application startup complete" doesn't mean the container survived. Check what happens
on the next line — and give boot its own time budget.
