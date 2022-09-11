FROM registry:latest as registry

FROM alpine:latest

COPY --from=registry /bin/registry /usr/local/bin/.

RUN apk add bash openssl

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

COPY ./config-example.yml /etc/docker/registry/config.yml
CMD ["/etc/docker/registry/config.yml"]
# VOLUME ["/var/lib/registry"]
EXPOSE 5000
