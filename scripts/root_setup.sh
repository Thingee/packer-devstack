#!/bin/sh -x

apt-get update -y -qq > /dev/null
apt-get install -y -q git

# Setup sudo to allow no-password sudo for "admin"
groupadd -r admin
usermod -a -G admin ubuntu
cp /etc/sudoers /etc/sudoers.orig
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers

mkdir /opt/stack; chown ubuntu:ubuntu /opt/stack
mkdir /var/log/stack; chown ubuntu:ubuntu /var/log/stack
