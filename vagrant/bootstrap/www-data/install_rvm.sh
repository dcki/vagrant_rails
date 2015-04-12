#!/usr/bin/env bash

# Echo all commands before executing.
set -v

# Install mpapis public key (recommended in RVM installation documentation).
# TODO Is this beneficial? Why does gpg always say "This key is not certified
# with a trusted signature" during RVM install? Can I fix that?
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
# The \ in \curl makes bash use unaliased curl if there is an alias. One person
# on stackoverflow claimed this doesn't matter for an install script because
# aliases won't be used, but keeping it here for consistency in case someone
# copy-pastes it from this script.
# curl -sSL makes curl not show progress, report errors, and follow redirects.
\curl -sSL https://get.rvm.io | bash -s stable

# Stop echoing commands (see top).
set +v
