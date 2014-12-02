#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${DIR}"

: ${TEMPLATE_DIR:=${DIR}/templates}
: ${CONSUL_TEMPLATE_EXEC:=$(which consul-template) -consul 127.0.0.1:8500}
: ${NGINX_SITES_DIR:=/etc/nginx/sites-enabled}

mkdir -p "${TEMPLATE_DIR}"
rm -f "${TEMPLATE_DIR}/*"  # force consul-template to rewrite them in case the source changed

SED_ARGS=(-e "s!%CONSUL_TEMPLATE_EXEC%!${CONSUL_TEMPLATE_EXEC}!g" -e "s:%TEMPLATE_DIR%:${TEMPLATE_DIR}:g" -e "s:%NGINX_SITES_DIR%:${NGINX_SITES_DIR}:g")

sed "${SED_ARGS[@]}" < webapp-nginx.outer-ctmpl > "${TEMPLATE_DIR}/webapp-nginx.outer-ctmpl"
sed "${SED_ARGS[@]}" < consul-template-webapp-nginx-0.upstart > /etc/init/consul-template-webapp-nginx-0.conf
sed "${SED_ARGS[@]}" < consul-template-webapp-nginx-1.upstart.ctmpl > "${TEMPLATE_DIR}/consul-template-webapp-nginx-1.upstart.ctmpl"

service consul-template-webapp-nginx-0 restart
