FROM golang:1.17-alpine as registry


ENV GO111MODULE=auto
ENV DISTRIBUTION_DIR /go/src/github.com/distribution/distribution
ENV BUILDTAGS include_oss include_gcs

ARG GOOS=linux
ARG GOARCH=amd64
ARG VERSION
ARG REVISION=cc4627f

RUN set -ex \
	&& apk add --no-cache make git file \
	&& git clone https://github.com/distribution/distribution $DISTRIBUTION_DIR
WORKDIR $DISTRIBUTION_DIR
COPY . $DISTRIBUTION_DIR
RUN CGO_ENABLED=0 make PREFIX=/go clean binaries && file ./bin/registry | grep "statically linked"

FROM alpine:latest

COPY --from=registry /go/src/github.com/distribution/distribution/bin /usr/local/bin/.

RUN apk add bash openssl

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

COPY ./config-example.yml /etc/docker/registry/config.yml
CMD ["/etc/docker/registry/config.yml"]
# VOLUME ["/var/lib/registry"]
EXPOSE 5000
