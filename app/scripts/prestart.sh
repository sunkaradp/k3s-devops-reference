#!/usr/bin/env bash
set -e
set -x
# Runs on every pod start. Skips migrations in k8s (RUN_MIGRATIONS=false);
# still migrates for local/compose where the flag defaults to true.
python app/backend_pre_start.py
if [ "${RUN_MIGRATIONS:-true}" = "true" ]; then
    alembic upgrade heads
    python app/initial_data.py
fi
