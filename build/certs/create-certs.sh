#!/bin/bash
set -e

# Create certificates directory
mkdir -p /tmp/certificates && mkdir -p /certificates/{agents,nats,ocsp,notification-worker,cert-manager-worker,agents-worker,ca,users,console,updater} 
cd /tmp

# Create CA certificate and private key
if [ ! -f /certificates/ca/ca.cer ] && [ ! -f /certificates/ca/ca.key ]; then
    /bin/openuem-cert-manager create-ca --name "OpenUEM CA" --dst "/certificates/ca" \
        --org "$ORGNAME" --country "$COUNTRY" --province "$ORGPROVINCE" --locality "$ORGLOCALITY" \
        --address "$ORGADDRESS" --years-valid 10
fi

# Create NATS server certificate and private key
if [ ! -f /certificates/nats/nats.cer ] && [ ! -f /certificates/nats/nats.key ]; then
    /bin/openuem-cert-manager server-cert --name "OpenUEM NATS" --dst "/certificates/nats" \
        --type="nats" --client-too --dns-names "$NATS_SERVER,nats-server,localhost" --org "$ORGNAME" \
        --country "$COUNTRY" --province "$ORGPROVINCE" --locality "$ORGLOCALITY" \
        --address "$ORGADDRESS" --years-valid 2 --filename "nats" \
        --ocsp "$OCSP" \
        --dburl "$DATABASE_URL" --description "NATS certificate" \
        --cacert "/certificates/ca/ca.cer" --cakey "/certificates/ca/ca.key" 
fi

# Create OCSP server certificate and private key
if [ ! -f /certificates/ocsp/ocsp.cer ] && [ ! -f /certificates/ocsp/ocsp.key ]; then
    /bin/openuem-cert-manager server-cert --name "OpenUEM OCSP" --dst "/certificates/ocsp" \
        --type="ocsp" --sign-ocsp --org "$ORGNAME" --country "$COUNTRY" --province "$ORGPROVINCE" \
        --locality "$ORGLOCALITY" --address "$ORGADDRESS" --years-valid 2 --filename "ocsp" \
        --ocsp "$OCSP" --description "OCSP certificate" \
        --cacert "/certificates/ca/ca.cer" --cakey "/certificates/ca/ca.key" --dburl "$DATABASE_URL" 
fi

# Create notification worker client certificate and private key
if [ ! -f /certificates/notification-worker/worker.cer ] && [ ! -f /certificates/notification-worker/worker.key ]; then
    /bin/openuem-cert-manager client-cert --name "OpenUEM Notification Worker" \
    --dst "/certificates/notification-worker" --type="worker" --org "$ORGNAME" \
    --country "$COUNTRY" --province "$ORGPROVINCE" --locality "$ORGLOCALITY" \
    --address "$ORGADDRESS" --years-valid 2 --filename "worker" \
    --ocsp "$OCSP" --description "Notification Worker's certificate" \
    --cacert "/certificates/ca/ca.cer" --cakey "/certificates/ca/ca.key" --dburl "$DATABASE_URL" 
fi

# Create cert-manager worker client certificate and private key
if [ ! -f /certificates/cert-manager-worker/worker.cer ] && [ ! -f /certificates/cert-manager-worker/worker.key ]; then
    /bin/openuem-cert-manager client-cert --name "OpenUEM Cert-Manager Worker" \
    --dst "/certificates/cert-manager-worker" --type="worker" --org "$ORGNAME" \
    --country "$COUNTRY" --province "$ORGPROVINCE" --locality "$ORGLOCALITY" \
    --address "$ORGADDRESS" --years-valid 2 --filename "worker" \
    --ocsp "$OCSP" --description "Cert-Manager Worker's certificate" \
    --cacert "/certificates/ca/ca.cer" --cakey "/certificates/ca/ca.key" --dburl "$DATABASE_URL" 
fi

# Create agent worker client certificate and private key
if [ ! -f /certificates/agents-worker/worker.cer ] && [ ! -f /certificates/agents-worker/worker.key ]; then
    /bin/openuem-cert-manager client-cert --name "OpenUEM Agent Worker" \
    --dst "/certificates/agents-worker" --type="worker" --org "$ORGNAME" \
    --country "$COUNTRY" --province "$ORGPROVINCE" --locality "$ORGLOCALITY" \
    --address "$ORGADDRESS" --years-valid 2 --filename "worker" \
    --ocsp "$OCSP" --description "Agent Worker's certificate" \
    --cacert "/certificates/ca/ca.cer" --cakey "/certificates/ca/ca.key" --dburl "$DATABASE_URL" 
fi

# Create console client/server certificate and private key 
if [ ! -f /certificates/console/console.cer ] && [ ! -f /certificates/console/console.key ]; then
    /bin/openuem-cert-manager server-cert --name "OpenUEM Console" --dst "/certificates/console" \
    --type="console" --client-too --dns-names "$SERVER_NAME,console,localhost" --org "$ORGNAME" \
    --country "$COUNTRY" --province "$ORGPROVINCE" --locality "$ORGLOCALITY" \
    --address "$ORGADDRESS" --years-valid 2 --filename "console" \
    --ocsp "$OCSP" --description "Console certificate" \
    --cacert "/certificates/ca/ca.cer" --cakey "/certificates/ca/ca.key" --dburl "$DATABASE_URL" 
fi

# Create console reverse proxy certificate and private key
if [ -n "$REVERSE_PROXY_SERVER" ] && [ ! -f /certificates/console/proxy.cer ] && [ ! -f /certificates/console/proxy.key ]; then
    /bin/openuem-cert-manager server-cert --name "OpenUEM Reverse Proxy" --dst "/certificates/console" \
    --type="proxy" --dns-names "$REVERSE_PROXY_SERVER" --org "$ORGNAME" \
    --country "$COUNTRY" --province "$ORGPROVINCE" --locality "$ORGLOCALITY" \
    --address "$ORGADDRESS" --years-valid 2 --filename "proxy" \
    --ocsp "$OCSP" --description "Reverse Proxy certificate" \
    --cacert "/certificates/ca/ca.cer" --cakey "/certificates/ca/ca.key" --dburl "$DATABASE_URL"
fi

# Create console SFTP credentials both certificate and private key
if [ ! -f /certificates/console/sftp.cer ] && [ ! -f /certificates/console/sftp.key ]; then
    /bin/openuem-cert-manager client-cert --name "OpenUEM SFTP Client" --dst "/certificates/console" \
    --type="console" --org "$ORGNAME" --country "$COUNTRY" \
    --province "$ORGPROVINCE" --locality "$ORGLOCALITY" \
    --address "$ORGADDRESS" --years-valid 2 --filename "sftp" \
    --ocsp "$OCSP" --description "SFTP Client" \
    --cacert "/certificates/ca/ca.cer" --cakey "/certificates/ca/ca.key" --dburl "$DATABASE_URL"
fi

# Create server updater certificate and private key
if [ ! -f /certificates/updater/updater.cer ] && [ ! -f /certificates/updater/updater.key ]; then
    /bin/openuem-cert-manager client-cert --name "OpenUEM Updater Client" --dst "/certificates/updater" \
    --type="updater" --org "$ORGNAME" --country "$COUNTRY" \
    --province "$ORGPROVINCE" --locality "$ORGLOCALITY" \
    --address "$ORGADDRESS" --years-valid 2 --filename "updater" \
    --ocsp "$OCSP" --description "Updater Client" \
    --cacert "/certificates/ca/ca.cer" --cakey "/certificates/ca/ca.key" --dburl "$DATABASE_URL"
fi

# Create agent client/server certificate and private key 
if [ ! -f /certificates/agents/agent.cer ] && [ ! -f /certificates/agents/agent.key ]; then
    /bin/openuem-cert-manager client-cert --name "OpenUEM Agent" --dst "/certificates/agents" \
    --type="agent" --org "$ORGNAME" --country "$COUNTRY" --province "$ORGPROVINCE" --locality "$ORGLOCALITY" \
    --address "$ORGADDRESS" --years-valid 2 --filename "agent" \
    --ocsp "$OCSP" --description "Agent certificate" \
    --cacert "/certificates/ca/ca.cer" --cakey "/certificates/ca/ca.key" --dburl "$DATABASE_URL"
fi

# Create admin client certificate and private key for console access
if [ ! -f /certificates/users/admin.pfx ]; then
    /bin/openuem-cert-manager user-cert --username admin --dst "/certificates/users" \
    --org "$ORGNAME" --country "$COUNTRY" --province "$ORGPROVINCE" --locality "$ORGLOCALITY" \
    --address "$ORGADDRESS" --years-valid 2 \
    --ocsp "$OCSP" --description "OpenUEM Administrator" \
    --cacert "/certificates/ca/ca.cer" --cakey "/certificates/ca/ca.key" --dburl "$DATABASE_URL"
fi