FROM debian:latest AS build
RUN apt-get update -y && apt install dos2unix -y
COPY ./init.sh /tmp/init.sh
RUN dos2unix /tmp/init.sh

FROM postgres
ENV POSTGRES_USER=postgres

ARG DATABASE_NAME
ENV DATABASE_NAME=$DATABASE_NAME

ARG DATABASE_USER
ENV DATABASE_USER=$DATABASE_USER

ARG DATABASE_PASSWORD
ENV DATABASE_PASSWORD=$DATABASE_PASSWORD

COPY --from=build /tmp/init.sh /docker-entrypoint-initdb.d/