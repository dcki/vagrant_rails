#!/usr/bin/env bash

# Echo all commands before executing.
set -v

# TODO When there is a moderate amount of application code to test with, try
# Phusion Passenger, do performance testing, and compare performance to Puma.

# Start Puma.
vpuma restart development
# See apache/common.conf for Apache proxy port.
# TODO If the platform or Vagrantfile config allows it, then Puma's port may be
# publicly accessible. That may be bad. One of the reasons that I've read to
# use an Apache or nginx proxy in front of Puma is that they may help shield
# Puma from hacking attempts. Access to Puma's port from anywhere other than
# localhost should probably be blocked. iptables or another firewall might
# help.

# Configure Apache.

# Enable modules.
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

# Enable the site.
ln -s /vagrant/apache/common.conf /etc/apache2/common.conf
ln -s /vagrant/apache/site /etc/apache2/sites-available/site
a2ensite site
# TODO Don't enable ssl until it's ready for production.
#ln -s /vagrant/apache/ssl /etc/apache2/sites-available/ssl
#a2ensite ssl

# Start Apache.
service apache2 restart

# Stop echoing commands (see top).
set +v
