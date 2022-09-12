FROM distribution/distribution@sha256:53290011528bf7aa130c6aab42d6129b914545feca1a216deba81a574ac80eb5 as registry

RUN apk add bash openssl

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

COPY ./config-example.yml /etc/docker/registry/config.yml
CMD ["registry", "serve", "/etc/docker/registry/config.yml"]
# VOLUME ["/var/lib/registry"]
EXPOSE 5000
