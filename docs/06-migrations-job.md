# 6. Safe Database Migrations (one-off Job)

## The problem: migrate-on-startup

A common pattern runs DB migrations in the container's startup script — fine with
one replica, but during a rolling update the new pod starts while the old one is
still running. For a moment two pods hit the same database, both trying to migrate.
That's a race condition that can corrupt your schema, and it won't show in a log
until the day it fails.

## The fix: run migrations once, as a Job

Pull migrations out of pod startup. Run them a single time as a Kubernetes `Job`,
before the app rolls out. Split the scripts:

- `migrate.sh` — wait for DB, run migrations, seed data. (Runs in the Job.)
- `prestart.sh` — pod startup; skips migrations when `RUN_MIGRATIONS=false`.

```sh
# prestart.sh
python app/backend_pre_start.py
if [ "${RUN_MIGRATIONS:-true}" = "true" ]; then
    alembic upgrade heads
    python app/initial_data.py
fi
```

Set `RUN_MIGRATIONS=false` on the app Deployment so pods never migrate — the Job does.
Keep the default `true` for local/compose so those still migrate normally.

## Wire it into the pipeline

```sh
kubectl delete job backend-migrate -n NS --ignore-not-found
kubectl apply -f k8s/base/backend/migration-job.yaml -n NS
kubectl wait --for=condition=complete job/backend-migrate -n NS --timeout=300s
kubectl set image deploy/backend backend=IMAGE:TAG -n NS
```

## Gotcha: Kustomize hashed secret names

If Kustomize generates hashed secret names, a raw `kubectl apply -f job.yaml` won't
get the name rewritten the way the Deployment does — the Job fails with
`secret "backend-secret" not found`. Apply the Job through Kustomize
(`kubectl apply -k`) so it gets the same resolution. Hardcoding the hash works but
is brittle — it changes whenever the secret content changes.

## Takeaway

A pattern that's fine at one replica can become a liability at two. Migrations belong
in a run-once Job, not in every pod's startup.
