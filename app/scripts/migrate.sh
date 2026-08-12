#!/usr/bin/env bash
set -e
set -x
# Runs ONCE via the k8s migration Job.
python app/backend_pre_start.py   # wait for DB
alembic upgrade heads             # apply migrations
python app/initial_data.py        # seed initial data
