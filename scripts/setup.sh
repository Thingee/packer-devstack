#!/bin/sh -x

git clone https://github.com/openstack-dev/devstack.git

echo "[[local|localrc]]
ADMIN_PASSWORD=secrete
DATABASE_PASSWORD=secrete
RABBIT_PASSWORD=secrete
SERVICE_PASSWORD=secrete
SERVICE_TOKEN=a682f596-76f3-11e3-b3b2-e716f9080d50
SCREEN_LOGDIR=/var/log/stack" > devstack/local.conf

devstack/stack.sh

echo "OFFLINE=True" >> devstack/local.conf
