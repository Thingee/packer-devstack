#!/bin/bash -x

set -e

# Updating and Upgrading dependencies
sudo apt-get update -y -qq > /dev/null
sudo apt-get upgrade -y -qq > /dev/null

# Install necessary libraries for guest additions and Vagrant NFS Share
sudo apt-get -y -q install linux-headers-$(uname -r) build-essential

# Install necessary dependencies
sudo apt-get -y -q install curl wget git vim

# Setup sudo to allow no-password sudo for "admin"
#groupadd -r admin
usermod -a -G admin ubuntu
cp /etc/sudoers /etc/sudoers.orig
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers

sudo apt-get install -y git screen python-pip curl python-dev python-setuptools libmysqlclient-dev libpq-dev libxslt1-dev libxml2-dev libffi-dev bc

sudo mkdir /opt/stack; chown ubuntu:ubuntu /opt/stack
sudo mkdir /var/log/stack; chown ubuntu:ubuntu /var/log/stack

su ubuntu -c "git clone https://github.com/openstack-dev/devstack.git"
su ubuntu -c 'echo "[[local|localrc]]
ADMIN_PASSWORD=secrete
DATABASE_PASSWORD=secrete
RABBIT_PASSWORD=secrete
SERVICE_PASSWORD=secrete
SERVICE_TOKEN=a682f596-76f3-11e3-b3b2-e716f9080d50
TEMPEST_VOLUME_DRIVER=
TEMPEST_VOLUME_VENDOR=""
TEMPEST_STORAGE_PROTOCOL=
Q_USE_SECGROUP=False
LIBVIRT_FIREWALL_DRIVER=nova.virt.firewall.NoopFirewallDriver
CINDER_SECURE_DELETE=False
SCREEN_LOGDIR=/var/log/stack
DISABLED_SERVICES=q-svc,q-agt,q-dhcp,q-l3,h-eng,h-api,h-api-cfn,h-api-cw" >> devstack/local.conf'
su ubuntu -c devstack/stack.sh
mysqladmin -u root password secrete
echo "OFFLINE=True" >> devstack/local.conf
