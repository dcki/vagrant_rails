./root_user/first.sh
sudo -l ruby -c './ruby_user/install_rvm.sh'
sudo -l ruby -c './ruby_user/install_rubinius.sh'
sudo -l ruby -c './ruby_user/install_rails.sh'
# Always execute this last.
./root_user/start-apache.sh
