FROM nats:latest
COPY ./nats.cfg /etc/nats.cfg
EXPOSE 4433
EXPOSE 8443
CMD ["-c", "/etc/nats.cfg","-p", "4433", "-m", "8443"]