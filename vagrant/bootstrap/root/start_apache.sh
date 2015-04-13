#!/usr/bin/env bash

# Echo all commands before executing.
set -v

# Enable the site.
# If we enable the site earlier, while setting up, then everything in site
# directories, including source code, may be publicly accessible until
# installation is complete. Thus, ENABLE AT END OF ALL SETUP.
a2ensite site
#a2ensite ssl
service apache2 restart

# Stop echoing commands (see top).
set +v
