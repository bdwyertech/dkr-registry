FROM golang:1.15-alpine as registry

RUN apk add git \
	&& go get github.com/docker/distribution/cmd/registry

FROM alpine:latest

COPY --from=registry /go/bin/registry /usr/local/bin/.

RUN apk add bash openssl stunnel

CMD ["/bin/bash"]

COPY ./config-example.yml /etc/docker/registry/config.yml
# VOLUME ["/var/lib/registry"]
EXPOSE 5000

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
