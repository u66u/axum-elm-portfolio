#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Check if psql is installed
if ! command -v psql &> /dev/null; then
    echo "Error: psql is not installed"
    exit 1
fi

# Check if sqlx is installed
if ! command -v sqlx &> /dev/null; then
    echo "Error: sqlx is not installed"
    exit 1
fi

DB_USER="t"
DB_PASSWORD="testdbpass"
DB_NAME="portfolio-backend-axum-test"
DB_PORT="5432"

# Set database password
export PGPASSWORD="${DB_PASSWORD}"

# Check if Postgres is available
max_retries=100
for ((i=0; i<=max_retries; i++)); do
        if psql -h "localhost" -U "$DB_USER" -p "$DB_PORT" -d "postgres" -c '\q'; then
            break
        fi
        if [ $i -eq $max_retries ]; then
            echo "Postgres is still unavailable after ${max_retries} attempts, exiting"
            exit 1
        fi
        sleep 1
done

# Set the DATABASE_URL environment variable
export DATABASE_URL="postgres://${DB_USER}:${DB_PASSWORD}@localhost:${DB_PORT}/${DB_NAME}"

# Create the database using sqlx
sqlx database create

# Run migrations using sqlx
sqlx migrate run

# Execute the SQL script using psql, if it exists
if [ -f "./scripts/initial_data.sql" ]; then
    psql -h "localhost" -U "$DB_USER" -p "$DB_PORT" -d "$DB_NAME" -f "./scripts/initial_data.sql"
fi

echo "Postgres has been migrated, ready to go!"

# Write configuration to local.yaml
mkdir -p $(dirname configuration/local.yaml) # Ensures the configuration directory exists.
cat > configuration/local.yaml <<EOL
database:
  username: "${DB_USER}"
  password: "${DB_PASSWORD}"
  port: ${DB_PORT}
  host: "localhost"
  database_name: "${DB_NAME}"
application_port: 8080
EOL

echo "APP_ENVIRONMENT=\"local\"" >> .env
echo "FRONTEND_URL=\"http://localhost:1234\"" >> .env
echo "Configuration has been exported to configuration/local.yaml"

# Add DATABASE_URL to .env file
echo "DATABASE_URL=\"postgres://${DB_USER}:${DB_PASSWORD}@localhost:${DB_PORT}/${DB_NAME}\"" >> .env
echo "DATABASE_URL has been added to the .env file"
