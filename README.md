# OpenUEM - Docker

Repository containing the docker compose file to run OpenUEM in a container environment.

Docker images are stored in Docker Hub. In order to start all containers, a .env file must be created next to the compose.yml file

The .env file has this format:

```(bash)
POSTGRES_PORT=5432
DATABASE_URL="postgres://test:test@openuem-db-1:5432/openuem"
ORGNAME=
ORGPROVINCE=
ORGLOCALITY=
ORGADDRESS=
COUNTRY=
OCSP_PORT=8000
NATS_PORT=4433
REVERSE_PROXY_SERVER=
NATS_SERVERS=nats-server:4433
OCSP=http://ocsp-responder:8000
DOMAIN=openuem.eu
SERVER_NAME=yourservername
CONSOLE_PORT=1323
AUTH_PORT=1324
JWT_KEY=averylongsecret
```

POSTGRES_PORT will be used to set your postgres database available in your machine

The DATABASE_URL is in the format postgres://user:password@openuem-db-1:port/openuem

ORGNAME contains your organization's name and is required. COUNTRY is optional and should contain a two letter code for your organization's country.

SERVER_NAME should contain the domain name of your server. 

JWT_KEY should be set to an alphanumeric character string (max characters 32)

Once you create the .env file you can run OpenUEM with the following command:

`docker compose up --build -d`

Then you should import to your browser's certificates the CA certificate (certificates/ca/ca.cer) file to add a new certificate authority and the admin certificate as a personal certificate (certificates/users/admin.pfx) using 'changeit' as the password.

Finally visit https://yourservername:1323

You can stop the containers using:

`docker compose down`

## Notes

Important init.sh for Postgres file must be saved with LF as the bash shell expects to be in LF (set with VSCode) and not with CRLF
