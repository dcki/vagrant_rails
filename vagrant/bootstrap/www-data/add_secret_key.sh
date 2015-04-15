#!/usr/bin/env bash

set -v

# Add secret_key_base for Rails in production mode.

set +v
function_exists() {
  declare -f -F $1 > /dev/null
  return $?
}
if ! function_exists rvm; then
  echo 'RVM is not a function. Sourcing ~/.rvm/scripts/rvm';
  source ~/.rvm/scripts/rvm
fi
cd /var/www/rails
if ( [ ! -e .ruby-version ] || [ ! -e .ruby-gemset ] ) && [ ! -e .rvmrc ]; then
  # Missing .ruby-version or .ruby-gemset, and also no .rvmrc, so use this ruby
  # and gemset by default.
  rvm use ext-rbx-2.5.2@rails
fi
set -v
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
