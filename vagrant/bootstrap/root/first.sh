#!/usr/bin/env bash

# Echo all commands before executing.
set -v

# Put .gemrc in www-data home folder. (Prevent gem documentation installation.)
# See Vagrantfile for why we don't just mount /var/www/
ln -s /vagrant/home/www-data/.gemrc /var/www/.gemrc
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
rm /var/www/index.html
rm /etc/apache2/sites-enabled/*
# TODO Consider showing a maintenance page until deployment is complete.
ln -s /vagrant/apache/common.conf /etc/apache2/common.conf
ln -s /vagrant/apache/site /etc/apache2/sites-available/site
# TODO Don't enable ssl until it's ready for production.
#ln -s /vagrant/apache/ssl /etc/apache2/sites-available/ssl
#a2enmod rewrite
# Needed to connect Puma to Apache. See apache/common.conf.
a2enmod proxy
a2enmod proxy_http
# Set the FQDN (fully qualified domain name).
# (Stop "Could not reliably determine the server's fully qualified domain name"
# message.) See http://askubuntu.com/a/256018/207584
# TODO Replace localhost with the correct name when you know it.
echo "ServerName localhost" > /etc/apache2/conf.d/fqdn.conf
# To execute this manually:
#echo "ServerName localhost" | sudo tee /etc/apache2/conf.d/fqdn.conf
# On Ubuntu 14.04 (or maybe more precisely Apache 2.4)
#echo "ServerName localhost" > /etc/apache2/conf.d/fqdn.conf
#sudo a2enconf fqdn

# Fix sudo. Otherwise, sometimes PATH is wrong when using sudo and I have to
# `sudo su -l root -c '...'` instead. This often happens during
# `apt-get install`.
# No solution is known yet. This problem has not been observed lately, so when
# it is reproducible again a solution can be pursued.

# TODO Some of these packages sometimes take a long time to download. Consider
# hosting them from a shared folder or something.
# curl is required to download RVM.
# clang seems to be optional for building Rubinius, but it's cool.
# llvm v3.0-3.5 is required to build Rubinius 2.5.2.
# nodejs is for use by Rails as a JavaScript runtime.
# See https://github.com/rails/execjs
# Some versions of Nokogiri need libxml2-dev.
# See http://www.nokogiri.org/tutorials/installing_nokogiri.html
# Some (all?) versions of pg need libpq-dev.
# See http://stackoverflow.com/q/6040583/724752
# The rest of the packages listed are from `rvm requirements ruby-2.2.1`.
# See bootstrap/www-data/install-rubinius.sh
apt-get install -y curl clang-3.4 llvm-3.4 nodejs libxml2-dev libpq-dev gawk g++ libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake libtool bison pkg-config


# Stop echoing commands (see top).
set +v
