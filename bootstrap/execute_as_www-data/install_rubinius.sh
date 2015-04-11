#!/usr/bin/env bash

# Echo all commands before executing.
set -v

# Install Rubinius with rvm install.

# Install supported llvm version.
# http://stackoverflow.com/questions/14962192/how-to-choose-the-llvm-version-clang-is-using
# http://kwangyulseo.com/2014/02/05/using-multiple-llvm-versions-on-ubuntu/
#apt-get install -y llvm-3.4
# The -- on the end is required to prevent rvm from using the wrong llvm
# version. The Rubinius 2.5.2 configure script requires that llvm version
# 3.0-3.5 be used, and rvm is attempting to use llvm 2.9.
#rvm install rbx-2.5.2 --
#rvm install rbx --1.9
#rvm install rbx
# Try `rvm install rbx --debug` to get verbose output and possibly see what configure options it is trying to use.
# Is there any way to direct RVM where to download the source during rvm install rbx?
# (Like from https://s3.amazonaws.com/releases.rubini.us/rubinius-2.5.2.tar.bz2)
# From havenwood in #rvm freenode irc:
# You can override the setting in ~/.rvm/config/db by creating ~/.rvm/config/user with your preferred setting for any line.

# Install Rubinius with help from RVM.

# Lots of output, stop echoing commands.
set +v
HOME=/var/www/
source $HOME/.rvm/scripts/rvm
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
cd $HOME
set -v
\curl -sSL https://s3.amazonaws.com/releases.rubini.us/rubinius-2.5.2.tar.bz2 > rubinius-2.5.2.tar.bz2
tar xjf rubinius-2.5.2.tar.bz2
mv rubinius-2.5.2 rubinius-2.5.2-source
# Build Rubinius.
# RVM lots of output when using cd. One reason to consider using rbenv instead.
set +v
cd rubinius-2.5.2-source
set -v
bundle install
./configure --prefix=$HOME/rubinius-2.5.2-bin/ --cc=clang --cxx=clang++ --llvm-config=/usr/bin/llvm-config-3.4
# Install Rubinius.
rake install
set +v
# Add Rubinius to RVM.
rvm mount $HOME/rubinius-2.5.2-bin/ -n rbx-2.5.2
rvm alias create default ext-rbx-2.5.2
rvm use default
