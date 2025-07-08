CREATE
DATABASE IF NOT EXISTS traefik_db;

GRANT ALL PRIVILEGES ON traefik_db.* TO
'traefik_user'@'%';
FLUSH
PRIVILEGES;

USE traefik_db;