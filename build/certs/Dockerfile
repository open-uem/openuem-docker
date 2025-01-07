FROM debian:latest AS build
RUN apt-get update -y && apt install dos2unix -y
COPY ./create-certs.sh /tmp/create-certs.sh
RUN dos2unix /tmp/create-certs.sh

FROM openuem/openuem-cert-manager
COPY --from=build /tmp/create-certs.sh /bin/create-certs.sh
RUN chmod +x /bin/create-certs.sh