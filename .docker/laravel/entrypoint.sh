#!/bin/bash

set -e

if [ -f /var/www/.env ]; then
    export $(grep -v '^#' /var/www/.env | xargs)
else
    echo "Error: .env file not found"
    exit 1
fi

wait_for_mysql() {
    local attempt=1
    echo "Waiting for MySQL at ${DB_HOST}:${DB_PORT} to be ready..."
    while [ $attempt -le 12 ]; do
        if nc -z ${DB_HOST} ${DB_PORT} 2>/dev/null; then
            echo "Success: MySQL port is open and ready."
            sleep 2
            return 0
        fi
        echo "Attempt $attempt/12: MySQL is not ready yet. Retrying in 5 seconds..."
        sleep 5
        ((attempt++))
    done
    echo "Error: MySQL is not reachable after 12 attempts."
    exit 1
}
wait_for_mysql

composer install

yes | php artisan migrate
php artisan optimize:clear --no-interaction || true
php artisan optimize --no-interaction || true


crontab -l | { cat; echo "* * * * * /usr/local/bin/php /var/www/artisan schedule:run >> /var/www/storage/logs/cron.log 2>&1"; } | crontab -

cron

exec "$@"
