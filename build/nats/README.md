# OpenUEM Nats Server

Set configuration and document commands to run a docker NATS container to use it with OpenUEM

## Features

TLS will be set and mutual TLS authentication will be used

## Command

`docker run --rm --name nats-server --volume C:\Users\mcabr\go\src\github.com\doncicuto\openuem-nats-server\certificates:/etc/nats-certificates --volume C:\Users\mcabr\go\src\github.com\doncicuto\openuem-nats-server\nats.cfg:/etc/nats.cfg -p 4433:4433 -p8443:8443 nats -c /etc/nats.cfg -p 4433 -m 8
443`

## Bugs

I think there's a bug in https://github.com/nats-io/nats-server/blob/main/internal/ldap/dn.go#L15, where the last attribute from a DN string is not parsed and therefore the "DistinguishedNameMatch could not be used for auth" message shows. Report and issue
