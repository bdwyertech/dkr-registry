FROM golang:1.15-alpine as registry

RUN apk add git \
	&& go get github.com/docker/distribution/cmd/registry

FROM alpine:latest

COPY --from=registry /go/bin/registry /usr/local/bin/.

RUN apk add bash

CMD ["/bin/bash"]
