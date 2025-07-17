## Running the project

For running the project enter these commands

```
cp .env.example .env
chmod +x manage.sh
./manage.sh -s              # for running
./manage.sh -st             # for stopping the project
```

- Make sure you put correct env for backend and frontend based on the docker-composes.
- This project supposed to use on production environment and its not suitable for develop environment.
- Traefik panel credential:  
  username: admin
  password: Password

## Generate SSL

For generating ssl you can run this command:

```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout .docker/traefik/certs/local.key -out .docker/traefik/certs/local.crt \
    -config .docker/traefik/openssl.cnf
```
