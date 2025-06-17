FROM debian:latest AS build
RUN apt-get update -y && apt install dos2unix -y
ARG NATS_SERVER
ENV SERVER_NAME=$NATS_SERVER
ARG NATS_PORT
ENV NATS_PORT=$NATS_PORT
ARG ORGNAME
ENV ORGNAME=$ORGNAME
ARG ORGPROVINCE
ENV ORGPROVINCE=$ORGPROVINCE
ARG ORGLOCALITY
ENV ORGLOCALITY=$ORGLOCALITY
ARG ORGADDRESS
ENV ORGADDRESS=$ORGADDRESS
ARG COUNTRY
ENV COUNTRY=$COUNTRY
COPY ./generate-nats-conf.sh /bin/generate-nats-conf.sh
RUN dos2unix /bin/generate-nats-conf.sh
RUN chmod +x /bin/generate-nats-conf.sh
RUN /bin/generate-nats-conf.sh

FROM nats:latest
COPY --from=build /etc/nats.cfg /etc/nats.cfg
EXPOSE $NATS_PORT
CMD ["-c", "/etc/nats.cfg"]