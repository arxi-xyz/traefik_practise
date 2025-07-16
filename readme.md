## Generate SSL

for generating ssl code run this comand

```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout .docker/traefik/certs/local.key -out .docker/traefik/certs/local.crt \
    -config .docker/traefik/openssl.cnf
```
