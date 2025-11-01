FROM debian:trixie AS build
RUN apt-get update -y && apt install dos2unix -y
COPY ./init.sh /tmp/init.sh
RUN dos2unix /tmp/init.sh

FROM postgres:17
ENV POSTGRES_USER=postgres
COPY --from=build /tmp/init.sh /docker-entrypoint-initdb.d/