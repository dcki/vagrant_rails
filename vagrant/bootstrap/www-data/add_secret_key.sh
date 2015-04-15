#!/usr/bin/env bash

set -v

# Add secret_key_base for Rails in production mode.
set +v
cd /var/www/rails
set -v
if ( [ ! -e .ruby-version ] || [ ! -e .ruby-gemset ] ) && [ ! -e .rvmrc ]; then
  # Missing .ruby-version or .ruby-gemset, and also no .rvmrc, so use this ruby
  # and gemset by default.
  rvm use ext-rbx-2.5.2@rails
fi
# Create secret_key_base.
SKB_FILE=~/.secret_key_base
echo "export SECRET_KEY_BASE=$(RAILS_ENV=production bundle exec rake secret)" > $SKB_FILE
set +v
. $SKB_FILE
set -v
echo ". $SKB_FILE" | tee -a ~/.bashrc ~/.bash_profile
# Keep this secret.
chmod o-rwx $SKB_FILE

set +v
