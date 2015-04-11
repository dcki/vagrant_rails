#!/usr/bin/env bash

# Echo all commands before executing.
set -v

# Put .gemrc in home folder. (Prevent gem documentation installation.)
#ln -s /vagrant/home/.gemrc /home/vagrant/.gemrc

apt-get update

# Set the server timezone to Pacific Time.
echo "America/Los_Angeles" > /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata

# TODO Try nginx
# TODO If Apache can be installed after Passenger or Puma, move all Apache
# installation and config to start-apache.sh. However you may want to leave
# some basic Apache setup here so that a maintenance page can be displayed
# during deployment.
# Install Apache.
# RUNLEVEL=1 prevents Apache from starting immediately after being installed.
# See http://askubuntu.com/a/75560/207584
RUNLEVEL=1 apt-get install -y apache2
# DANGER!
# Apache should not start because of the RUNLEVEL=1 above, but if it does
# start and then does not stop here, the default config makes everything under
# /var/www readable to clients for duration of deployment!!! Including
# /var/www/rails! For more ways to prevent this, like using iptables or another
# firewall to keep the server inaccessible during deployment, see
# http://serverfault.com/q/681588/253409
# Extra precaution.
service apache2 stop
rm /etc/apache2/sites-enabled/*
# TODO Consider showing a maintenance page until deployment is complete.
ln -s /vagrant/apache/common.conf /etc/apache2/common.conf
ln -s /vagrant/apache/site /etc/apache2/sites-available/site
ln -s /vagrant/apache/ssl /etc/apache2/sites-available/ssl
a2enmod rewrite

# Fix sudo. Otherwise, sometimes PATH is wrong when using sudo and I have to
# `sudo su -l root -c '...'` instead. This often happens during
# `apt-get install`.
# No solution is known yet. This problem has not been observed lately, so when
# it is reproducible again a solution can be pursued.

# curl is required to download RVM.
# clang seems to be optional for building Rubinius, but it's cool.
# llvm v3.0-3.5 is required to build Rubinius 2.5.2.
apt-get install -y curl clang-3.4 llvm-3.4

# Stop echoing commands (see top).
set +v
