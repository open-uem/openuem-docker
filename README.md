# OpenUEM - Docker

Repository containing the docker compose file to run OpenUEM in a container environment.

OpenUEM can be run using Docker/Podman containers that are hosted on [Docker Hub](https://hub.docker.com/u/openuem)

> [!WARNING]
> For deployments carried out before December 22, 2025, breaking changes are introduced. Please see the note later in this document.

You can use [docker compose](https://docs.docker.com/compose/)
or [podman compose](https://github.com/containers/podman-compose) to install and run all OpenUEM components on a single machine following these steps:

1) Clone the `openuem-docker` repository:

```(bash)
git clone https://github.com/open-uem/openuem-docker`
```

2) Use the file named `.env-example` file to create a `.env` file. The file must be named `.env` without extension and with a dot before the env word as required by Docker to read the environment variables. In the `.env` file, edit the environment variables that docker compose will use to build and get the containers up and running. The `.env-example` you just copied already sets up a working demo instance of OpenUEM on the `openuem.example` domain. If you want to simply try out OpenUEM you can just use it as-is. If you want to setup a  production system or use your own domain and information, you can customize the `.env` you just created.

> [!CAUTION]
> It's strongly recommended to change the JWT key with a random 32 characters long string

> [!IMPORTANT]
> It is possible to only use one domain for all services, but `CONSOLE_HOST`, `OPENUEM_NATS_SERVERS` and `NATS_HOST` should be resolved by your DNS service. If you are just locally deploying a demo instance and don't have access to a DNS, you can override your devices `hosts` configuration and allow local domain resolution. If you're using the default openuem.example domain you'll need to add an entry in your DNS or your hosts file.
> - On Windows: the configuration can be found under `C:\Windows\System32\drivers\etc\hosts`
> - On Linux: this configuration can be found under `/etc/hosts`
> - On macOS: the configuration can be found under /private/etc/hosts

> It is **important** that you use your **local ip address** (e.g. 192.168.1.43) **instead** of localhost or 127.0.0.1. Docker will copy these
>overrides into the containers on start. If you use localhost, each container will only try to connect to itself, making proper domain resolution impossible.

> [!NOTE]
> Please read the [docs](https://openuem.eu/docs/Installation/Server/docker) to know more about the env variables and how to deploy OpenUEM with Caddy as a reverse proxy.

3) Where the `compose.yaml` file and the .env files are located, execute the following command: 

```(bash)
docker compose up openuem-certs -d
```
This command will create the database service, create the nats folder and the NATS configuration file, and generate all the certificates required by OpenUEM. The certificates will be located in the certificates folder. 

> [!NOTE]
> The generation of certificates can take some time, don't stop the containers or go to the next step until you check that certificates have been indeed created. If you find two files under the `agents` folder and one `.pfx` file inside the `users` folder, you're good to go.

4) Once you've checked that the certificates folder have been generated, that all the certificates have been created and the nats folder contains the nats.cfg file , run the following commands to launch the remaining services: 

```(bash)
docker compose up -d
```

5) You can use `docker compose logs -f` to see the logs from the OpenUEM services. If you find any error trying to launch the services, run the `docker compose down` or `podman compose down` commands shown below, **remove the volumes and the certificates folder** and start again. You can use the -v flag to remove the volumes used by the postgres database and the NATS server.

## Notes for deployments carried out before December 22, 2025

The previous version of this repository contained environment variables that have been replaced or renamed. Additionally, a build folder containing scripts for generating the database and NATS configuration has been removed. If you wish to update your Docker deployment, please use the following information.

> [!CAUTION]
> Do not delete the volume used by the Postgres container to ensure the database remains intact when updating containers. Do not use the -v option with Docker Compose to prevent the deletion of the Postgres volume.


1) Remove the old containers. Run the following commands from the folder where your old deployment was created. 

```(bash)
docker compose --profile openuem down
docker compose --profile init down
```

2) Clone the new repository

```(bash)
git clone https://github.com/open-uem/openuem-docker
```

3) Rename the new openuem-docker repository folder to openuem. This is needed to ease the reuse of the previous Docker volumes that contain the database and the NATS streams.

4) Use the file named `.env-example` file to create a `.env` file. Set the new variable values using the following table to help you migrate your old .env definitions:

| Old variable name  | New variable name    |
|--------------------|----------------------|
| POSTGRES_PORT      | DATABASE_PORT        |
| DATABASE_URL       | DATABASE_USER        |
| DATABASE_URL       | DATABASE_PASSWORD    |
| DATABASE_URL       | DATABASE_DB_NAME     |
| ORGNAME            | OPENUEM_ORGNAME      |
| ORGPROVINCE        | OPENUEM_ORGPROVINCE  |
| ORGLOCALITY        | OPENUEM_ORGLOCALITY  |
| ORGADDRESS         | OPENUEM_ORGADDRESS   |
| COUNTRY            | OPENUEM_ORGCOUNTRY   |
| DOMAIN             | OPENUEM_DOMAIN       |
| AUTH_PORT          | CONSOLE_AUTH_PORT    |
| JWT_KEY            | CONSOLE_JWT_KEY      |
| SERVER_NAME        | CONSOLE_HOST         |
| SERVER_NAME        | OCSP_HOST            |
| SERVER_NAME        | NATS_HOST            |
| NATS_SERVERS       | OPENUEM_NATS_SERVER  |

The old NATS_SERVERS variable has been replaced with two variables NATS_HOST and NATS_PORT.

The old OCSP variable has been replaced with two variables OCSP_HOST and OCSP_PORT.

The old SERVER_NAME was used to assign the console hostname, the ocsp responder URL, and the NATS_SERVERS variable. You must specify the CONSOLE_HOST, OCSP_HOST, NATS_HOST accordingly.

5) Create a certificates folder and copy the contents of the old certificates folder where your old deployment was created.

6) Run `docker compose up -d` from the new folder. The new images will be pulled and the new services will be started.