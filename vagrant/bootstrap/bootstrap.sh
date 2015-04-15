# Echo all commands before executing.
set -v

/vagrant/bootstrap/root/first.sh
su -l www-data -s /bin/bash -c "/vagrant/bootstrap/www-data/install_rvm.sh"
su -l www-data -s /bin/bash -c "/vagrant/bootstrap/www-data/install_rubinius.sh"
su -l www-data -s /bin/bash -c "/vagrant/bootstrap/www-data/install_rails.sh"
su -l www-data -s /bin/bash -c "/vagrant/bootstrap/www-data/add_secret_key.sh"
# Always execute this last.
/vagrant/bootstrap/root/start_apache.sh

# Stop echoing commands.
set +v
