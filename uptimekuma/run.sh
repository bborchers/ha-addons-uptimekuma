#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

set -e

export NODE_PATH=/opt/node_modules

cd /opt/uptime-kuma || bashio::exit.nok "Could not change directory to Uptime Kuma"

bashio::log.info "Starting Uptime Kuma..."
exec node server/server.js --data-dir="/data/"
