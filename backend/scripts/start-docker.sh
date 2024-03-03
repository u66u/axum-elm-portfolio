set -e


if ! command -v docker &> /dev/null || ! command -v docker-compose &> /dev/null; then
    echo "Error: docker and docker-compose are not installed"
    exit 1
fi

DB_USER="t"
DB_PASSWORD="testdbpass"
DB_NAME="portfolio-backend-axum"
DB_PORT="5432"


export DB_USER DB_PASSWORD DB_NAME DB_PORT

docker-compose up -d

echo "Starting docker-compose..."
