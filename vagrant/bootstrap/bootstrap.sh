/vagrant/bootstrap/root/first.sh
# When Vagrant mounts /var/www/rails the /var/www directory is created and
# owned by root.
chown www-data:www-data /var/www
WWW_DATA_HOME=/var/www/
su -l www-data -s /bin/bash -c "HOME=$WWW_DATA_HOME /vagrant/bootstrap/www-data/install_rvm.sh"
su -l www-data -s /bin/bash -c "HOME=$WWW_DATA_HOME /vagrant/bootstrap/www-data/install_rubinius.sh"
su -l www-data -s /bin/bash -c "HOME=$WWW_DATA_HOME /vagrant/bootstrap/www-data/install_rails.sh"
# Always execute this last.
/vagrant/bootstrap/root/start_apache.sh
