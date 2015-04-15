#!/usr/bin/env bash

# Echo all commands before executing.
set -v

# Since this whole alternative section is currently commented out, stop echoing
# everything.
set +v

# TODO Try installing Rubinius with RVM instead.

# Install Rubinius with rvm install.

# Install supported llvm version.
# version. The Rubinius 2.5.2 configure script requires that llvm version
# 3.0-3.5 be used, and rvm is attempting to use llvm 2.9.
#rvm install rbx-2.5.2
# Try `rvm install rbx --debug` to get verbose output and possibly see what configure options it is trying to use.
# Is there any way to direct RVM where to download the source during rvm install rbx?
# (Like from https://s3.amazonaws.com/releases.rubini.us/rubinius-2.5.2.tar.bz2)
# From havenwood in #rvm freenode irc:
# You can override the setting in ~/.rvm/config/db by creating ~/.rvm/config/user with your preferred setting for any line.

#rvm use rbx-2.5.2@rails --create
set -v

# Install Rubinius with help from RVM.

# Lots of output, stop echoing commands.
set +v
source ~/.rvm/scripts/rvm
# Configure RVM to report, but not install, missing required packages.
# Installing them with RVM would require typing a password.
# If any packages are missing, install them in first.sh.
# See http://stackoverflow.com/a/17219765/724752 and
# http://stackoverflow.com/a/23601941/724752
rvm autolibs fail
RVM_AUTOLIBS_MESSAGE="If RVM tells you to enable autolibs, ignore it. Instead, install any missing packages in bootstrap/root/first.sh."
echo $RVM_AUTOLIBS_MESSAGE
# Print required missing packages.
rvm requirements ruby-2.2.1
echo $RVM_AUTOLIBS_MESSAGE
# Install Ruby 2.x.x, required to build Rubinius.
# Using ruby-2.2.1 because it's the current stable version and has successfully
# been used several times to build Rubinius.
echo 'rvm install ruby-2.2.1'
# RVM produces lots of output when it downloads stuff. Could silence with
# >/dev/null, but there may be times when the output is important. (There
# doesn't currently seem to be an option to tell RVM to not show download
# progress. Would make a good pull request.)
rvm install ruby-2.2.1
rvm gemset create build-rubinius
rvm use ruby-2.2.1@build-rubinius
gem install bundler
# Download Rubinius.
cd ~
set -v
# TODO Provide this installer in a synced folder rather than downloading it.
\curl -sSL https://s3.amazonaws.com/releases.rubini.us/rubinius-2.5.2.tar.bz2 > rubinius-2.5.2.tar.bz2
tar xjf rubinius-2.5.2.tar.bz2
mv rubinius-2.5.2 rubinius-2.5.2-source
# Build Rubinius.
# RVM lots of output when using cd. One reason to consider using rbenv instead.
set +v
cd rubinius-2.5.2-source
set -v
bundle install
./configure --prefix=~/rubinius-2.5.2-bin/ --cc=clang --cxx=clang++ --llvm-config=/usr/bin/llvm-config-3.4
# Install Rubinius.
rake install
set +v
# Add Rubinius to RVM.
rvm mount ~/rubinius-2.5.2-bin/ -n rbx-2.5.2
rvm alias create default ext-rbx-2.5.2
# These files don't seem to have any effect for some reason. But they do work in /var/www/rails.
#echo ext-rbx-2.5.2 > /var/www/.ruby-version
#echo rails > /var/www/.ruby-gemset
