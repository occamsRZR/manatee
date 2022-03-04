#!/bin/bash
source /root/.bashrc
nvm use v14.15.4
cd /app/assets || exit
npx browserslist@latest --update-db
cd /app || exit
# Wait until Postgres is ready.
while ! pg_isready -q -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER"
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

mix ecto.setup

mix phx.server
