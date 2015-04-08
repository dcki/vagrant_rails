#!/usr/bin/env bash

apt-get update

# Set the server timezone to Pacific Time.
echo "America/Los_Angeles" > /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata

# Install Apache.
apt-get install -y apache2
rm -rf /var/www
ln -fs /vagrant/www /var/www
rm /etc/apache2/sites-enabled/*
ln -s /vagrant/apache/common.conf /etc/apache2/common.conf
ln -s /vagrant/apache/site /etc/apache2/sites-available/site
ln -s /vagrant/apache/ssl /etc/apache2/sites-available/ssl
a2enmod rewrite

# Fix permissions.
# TODO Add more detail. What does this do? What permissions are we fixing?
rm /etc/apache2/httpd.conf
ln -s /vagrant/apache/httpd.conf /etc/apache2/httpd.conf

# TODO Install PostgreSQL instead.
# Install MySQL Server in a Non-Interactive mode. Root password will be test1234.
#echo "mysql-server-5.6 mysql-server/root_password password test1234" | sudo debconf-set-selections
#echo "mysql-server-5.6 mysql-server/root_password_again password test1234" | sudo debconf-set-selections
#apt-get install -y mysql-server libapache2-mod-auth-mysql php5-mysql

# TODO Install Rails instead.
# Install PHP.
#apt-get install -y php5 libapache2-mod-php5 php5-mcrypt
#sed -i 's/DirectoryIndex/DirectoryIndex index.php/g' /etc/apache2/mods-available/dir.conf

# Enable the site.
# If we enable the site earlier, while setting up, then everything in site
# directories, including source code, may be publicly accessible until
# installation is complete.
a2ensite site
a2ensite ssl
service apache2 restart
