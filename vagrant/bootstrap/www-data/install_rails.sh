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

set +v

function_exists() {
  declare -f -F $1 > /dev/null
  return $?
}
if ! function_exists rvm; then
  echo 'RVM is not a function. Sourcing ~/.rvm/scripts/rvm';
  source ~/.rvm/scripts/rvm
fi

# Because of rvm_install_on_use_flag=1 in .rvmrc, the ruby in .ruby-version
# should be installed automatically.
cd /var/www/rails
# Select correct gemset.
if ( [ ! -e .ruby-version ] || [ ! -e .ruby-gemset ] ) && [ ! -e .rvmrc ]; then
  # Missing .ruby-version or .ruby-gemset, and also no .rvmrc, so use this ruby
  # and gemset by default.
  rvm use ext-rbx-2.5.2@rails --create
fi
set -v

# Make sure Gemfile includes Puma.
if ! grep -qP -e "^\s*gem\s*[\"']puma[\"']" Gemfile; then
  # Need da Puma.
  printf "%s\n" \
    "" \
    "# This was added by vagrant_rails/vagrant/bootstrap/www-data/install_rails.sh" \
    "# because no \"gem 'puma'\" statement was detected." \
    "gem 'puma'" \
    >> Gemfile
fi

# Install gems from Gemfile.
bundle install

# Stop echoing commands (see top).
set +v
