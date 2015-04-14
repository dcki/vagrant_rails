#!/usr/bin/env bash

# Echo all commands before executing.
set -v

# Set language settings so gem installation succeeds. (Nokogiri and at least
# one other gem were failing to install with "error: control characters are not
# allowed at line 1 column 1".)
# See https://github.com/mperham/sidekiq/issues/929
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
echo "export LANGUAGE=en_US.UTF-8" | tee -a ~/.bashrc ~/.bash_profile
echo "export LANG=en_US.UTF-8" | tee -a ~/.bashrc ~/.bash_profile
echo "export LC_ALL=en_US.UTF-8" | tee -a ~/.bashrc ~/.bash_profile

# Install gems (like Puma) from Gemfile.
cd /var/www/rails
rvm use ext-rbx-2.5.2@rails
bundle install

# Add secret_key_base for Rails in production mode.
# TODO
# This all depends on there being a rails app in /var/www/rails and gems
# bundle-installed in ext-rbx-2.5.2@rails beforehand.
cd /var/www/rails
# Get the correct ruby and gemset for rake.
# TODO Maybe we should rely on .ruby-version and .ruby-gemset here since they
# seem to work in /var/www/rails (unlike /var/www).
rvm use ext-rbx-2.5.2@rails
# Create secret_key_base.
SKB_FILE=/var/www/.secret_key_base
echo "export SECRET_KEY_BASE=$(RAILS_ENV=production rake secret)" > $SKB_FILE
. $SKB_FILE
echo ". $SKB_FILE" | tee -a ~/.bashrc ~/.bash_profile
# Keep this secret.
chmod o-rwx $SKB_FILE

# TODO When there is a moderate amount of application code to test with, try
# Phusion Passenger, do performance testing, and compare performance to Puma.

# Start Puma. (Still need to start Apache in start_apache.sh.)
# Rely on /var/www/rails/Gemfile to include Puma. If the Gemfile does not
# include Puma and starting Puma thus fails, then I think it will be obvious
# from the error message what needs to be done.
bundle exec puma -e production
# See apache/common.conf for Apache proxy port.
# Start in development mode:
# bundle exec puma -b tcp://0.0.0.0:9292

# Stop echoing commands (see top).
set +v
