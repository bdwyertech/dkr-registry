#!/bin/bash -e
# Magic to Provision the Container
# Brian Dwyer - Intelligent Digital Services

if [ -n "$B64CONFIG" ]; then
	echo $B64CONFIG | base64 -d > /etc/docker/registry/config.yml
fi

if [ -n "$SETUP_SSL" ]; then
	# Create SSL Certificate
	mkdir -p /etc/docker/registry/ssl
	openssl ecparam -genkey -name secp384r1 | openssl ec -out /etc/docker/registry/ssl/key.pem 2>/dev/null
	openssl req -new -x509 -key /etc/docker/registry/ssl/key.pem -out /etc/docker/registry/ssl/cert.pem -days 3650 -subj "/C=US/O=GitHub/OU=BDwyerTech/CN=docker-registry"
	export REGISTRY_HTTP_TLS_CERTIFICATE='/etc/docker/registry/ssl/cert.pem'
	export REGISTRY_HTTP_TLS_KEY='/etc/docker/registry/ssl/key.pem'
fi

# if [ -n "$SETUP_REDIS_STUNNEL" ]; then
# fi

case "$1" in
    *.yaml|*.yml) set -- registry serve "$@" ;;
    serve|garbage-collect|help|-*) set -- registry "$@" ;;
	#
	# Other
	#
	* )	exec "$@";;
esac
