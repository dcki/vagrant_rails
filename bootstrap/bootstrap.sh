./root_user/first.sh
sudo -l www-data -c './www-data_user/install_rvm.sh'
sudo -l www-data -c './www-data_user/install_rubinius.sh'
sudo -l www-data -c './www-data_user/install_rails.sh'
# Always execute this last.
./root_user/start-apache.sh
