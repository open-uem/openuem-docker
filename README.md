# OpenUEM

Repository containing the docker compose file to run OpenUEM

## Notes

Important init.sh file must be saved with LF as the bash shell expects to be in LF (set with VSCode) and not with CRLF

## Doubts

Should we use /tmp as the workdir or should we use a more secure folder?

Should we set the DATABASE_URL as a Docker secret?

```
  console:
      image: doncicuto/openuem-console
      command: "start"
      env_file:
        - .env
      volumes:
        - ./certificates/console:/tmp/certificates
      ports:
        - 1323:1323
        - 1324:1324
      depends_on:
        openuem-certs:
          condition: service_completed_successfully
        db:
          condition: service_healthy
        nats-server:
          condition: service_started
```
