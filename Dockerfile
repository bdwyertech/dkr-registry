FROM golang:1.16-alpine as registry

RUN apk add git \
	&& go get github.com/docker/distribution/cmd/registry

FROM alpine:latest

COPY --from=registry /go/bin/registry /usr/local/bin/.

RUN apk add bash openssl

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

COPY ./config-example.yml /etc/docker/registry/config.yml
CMD ["/etc/docker/registry/config.yml"]
# VOLUME ["/var/lib/registry"]
EXPOSE 5000
