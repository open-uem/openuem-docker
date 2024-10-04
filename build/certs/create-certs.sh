#!/bin/bash

set -e

# Create certificates directory
mkdir -p /tmp/certificates && mkdir -p /certificates/{agent,nats,ocsp,notification-worker,cert-manager-worker,agents-worker,ca,users,console} 
cd /tmp

# Create CA certificate and private key
if [ ! -f /certificates/ca/ca.cer ] && [ ! -f /certificates/ca/ca.key ]; then
/bin/openuem-cert-manager create-ca --name "$CA_NAME" --org "$CA_ORG" \
    --country "$CA_COUNTRY" --province "$CA_PROVINCE" --locality "$CA_LOCALITY" \
    --address "$CA_ADDRESS" --postal-code "$CA_POSTAL_CODE" \
    --years-valid $CA_YEARS_VALID && \
cp /tmp/certificates/ca.* /certificates/ca/
fi

# Create NATS server certificate and private key
if [ ! -f /certificates/nats/nats.cer ] && [ ! -f /certificates/nats/nats.key ] && [ ! -f /certificates/nats/ca.cer ]; then
/bin/openuem-cert-manager server-cert --name "$NATS_CERT_NAME" --org "$CA_ORG" \
    --country "$CA_COUNTRY" --province "$CA_PROVINCE" --locality "$CA_LOCALITY" \
    --address "$CA_ADDRESS" --postal-code "$CA_POSTAL_CODE" \
    --years-valid $NATS_CERT_YEARS_VALID \
    --dns-names "nats-server" \
    --filename "nats" --ocsp "$OCSP" --description "NATS certificate" \
    --cacert "/certificates/ca/ca.cer" --cakey="/certificates/ca/ca.key" && \
cp /certificates/ca/ca.cer /certificates/nats/ && cp /tmp/certificates/nats.* /certificates/nats/
fi

# Create OCSP server certificate and private key
if [ ! -f /certificates/ocsp/ocsp.cer ] && [ ! -f /certificates/nats/ocsp.key ] && [ ! -f /certificates/ocsp/ca.cer ]; then
/bin/openuem-cert-manager server-cert --name "$OCSP_CERT_NAME" --org "$CA_ORG" \
    --country "$CA_COUNTRY" --province "$CA_PROVINCE" --locality "$CA_LOCALITY" \
    --address "$CA_ADDRESS" --postal-code "$CA_POSTAL_CODE" \
    --years-valid $OCSP_CERT_YEARS_VALID \
    --filename "ocsp" --ocsp "$OCSP" \
    --cacert "/certificates/ca/ca.cer" --cakey="/certificates/ca/ca.key"\
    --sign-ocsp --description "OCSP certificate" && \
cp /certificates/ca/ca.cer /certificates/ocsp/ && cp /tmp/certificates/ocsp.* /certificates/ocsp/
fi

# Create notification worker client certificate and private key
if [ ! -f /certificates/notification-worker/worker.cer ] && [ ! -f /certificates/notification-worker/worker.key ] && [ ! -f /certificates/notification-worker/ca.cer ]; then
/bin/openuem-cert-manager client-cert --name "OpenUEM Notification Worker" --org "$CA_ORG" \
    --country "$CA_COUNTRY" --province "$CA_PROVINCE" --locality "$CA_LOCALITY" \
    --address "$CA_ADDRESS" --postal-code "$CA_POSTAL_CODE" \
    --years-valid $CLIENT_CERT_YEARS_VALID \
    --filename "worker" --ocsp "$OCSP" \
    --cacert "/certificates/ca/ca.cer" --cakey="/certificates/ca/ca.key" \
    --type "worker" --dburl "$DATABASE_URL" --description "Worker's certificate" && \
mv /tmp/certificates/worker.* /certificates/notification-worker/ && cp /certificates/ca/ca.cer /certificates/notification-worker/
fi

# Create cert-manager worker client certificate and private key
if [ ! -f /certificates/cert-manager-worker/worker.cer ] && [ ! -f /certificates/cert-manager-worker/worker.key ] && [ ! -f /certificates/cert-manager-worker/ca.cer ]; then
/bin/openuem-cert-manager client-cert --name "OpenUEM Cert-Manager Worker" --org "$CA_ORG" \
    --country "$CA_COUNTRY" --province "$CA_PROVINCE" --locality "$CA_LOCALITY" \
    --address "$CA_ADDRESS" --postal-code "$CA_POSTAL_CODE" \
    --years-valid $CLIENT_CERT_YEARS_VALID \
    --filename "worker" --ocsp "$OCSP" \
    --cacert "/certificates/ca/ca.cer" --cakey="/certificates/ca/ca.key" \
    --type "worker" --dburl "$DATABASE_URL" --description "Worker's certificate" && \
mv /tmp/certificates/worker.* /certificates/cert-manager-worker/ && cp /certificates/ca/ca.* /certificates/cert-manager-worker/
fi

# Create cert-manager worker client certificate and private key
if [ ! -f /certificates/agents-worker/worker.cer ] && [ ! -f /certificates/agents-worker/worker.key ] && [ ! -f /certificates/agents-worker/ca.cer ]; then
/bin/openuem-cert-manager client-cert --name "OpenUEM Agent Worker" --org "$CA_ORG" \
    --country "$CA_COUNTRY" --province "$CA_PROVINCE" --locality "$CA_LOCALITY" \
    --address "$CA_ADDRESS" --postal-code "$CA_POSTAL_CODE" \
    --years-valid $CLIENT_CERT_YEARS_VALID \
    --filename "worker" --ocsp "$OCSP" \
    --cacert "/certificates/ca/ca.cer" --cakey="/certificates/ca/ca.key" \
    --type "worker" --dburl "$DATABASE_URL" --description "Worker's certificate" && \
mv /tmp/certificates/worker.* /certificates/agents-worker/ && cp /certificates/ca/ca.cer /certificates/agents-worker/
fi

# Create console client/server certificate and private key 
if [ ! -f /certificates/console/console.cer ] && [ ! -f /certificates/console/console.key ] && [ ! -f /certificates/console/ca.cer ]; then
/bin/openuem-cert-manager server-cert --name "$CONSOLE_CERT_NAME" --org "$CA_ORG" \
    --country "$CA_COUNTRY" --province "$CA_PROVINCE" --locality "$CA_LOCALITY" \
    --address "$CA_ADDRESS" --postal-code "$CA_POSTAL_CODE" \
    --years-valid $CONSOLE_CERT_YEARS_VALID \
    --dns-names "console,localhost" \
    --filename "console" --ocsp "$OCSP" --client-too --description "Console certificate" \
    --cacert "/certificates/ca/ca.cer" --cakey="/certificates/ca/ca.key" && \
cp /certificates/ca/ca.cer /certificates/console/ && cp /tmp/certificates/console.* /certificates/console/
fi

# Create agent client/server certificate and private key 
if [ ! -f /certificates/agent/agent.cer ] && [ ! -f /certificates/agent/agent.key ] && [ ! -f /certificates/agent/ca.cer ]; then
/bin/openuem-cert-manager server-cert --name "$AGENT_CERT_NAME" --org "$CA_ORG" \
    --country "$CA_COUNTRY" --province "$CA_PROVINCE" --locality "$CA_LOCALITY" \
    --address "$CA_ADDRESS" --postal-code "$CA_POSTAL_CODE" \
    --years-valid $AGENT_CERT_YEARS_VALID \
    --dns-names "*.openuem.eu" \
    --filename "agent" --ocsp "$OCSP" --client-too --description "Agent certificate" \
    --cacert "/certificates/ca/ca.cer" --cakey="/certificates/ca/ca.key" && \
cp /certificates/ca/ca.cer /certificates/agent/ && cp /tmp/certificates/agent.* /certificates/agent/
fi

# Create admin client certificate and private key for console access
if [ ! -f /certificates/users/admin.cer ] && [ ! -f /certificates/users/admin.key ] && [ ! -f /certificates/users/ca.cer ]; then
/bin/openuem-cert-manager user-cert --username admin --org "$CA_ORG" \
    --country "$CA_COUNTRY" --province "$CA_PROVINCE" --locality "$CA_LOCALITY" \
    --address "$CA_ADDRESS" --postal-code "$CA_POSTAL_CODE" \
    --years-valid $CLIENT_CERT_YEARS_VALID \
    --ocsp "$OCSP" \
    --cacert "/certificates/ca/ca.cer" --cakey="/certificates/ca/ca.key" \
    --dburl "$DATABASE_URL" --description "Administrator's certificate" &&\
cp /tmp/certificates/admin.* /certificates/users/ && cp /certificates/ca/ca.cer /certificates/users/
fi