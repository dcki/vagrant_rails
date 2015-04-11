1. Install VirtualBox (preferably version 4.3.26 or greater)
- Install Vagrant
- Clone this Git project.
- `cd /path/to/project`
- `vagrant plugin install vagrant-vbguest`
- Download http://download.virtualbox.org/virtualbox/**YOUR_VBOX_VERSION**/VBoxGuestAdditions_**YOUR_VBOX_VERSION**.iso
- Update config.vbguest.iso_path in Vagrantfile to point to the VBoxGuestAdditions_**YOUR_VBOX_VERSION**.iso you downloaded.
- `vagrant up`!
Or, do this because of vagrant-vbguest?
- `vagrant up --no-provision; vagrant reload`

Remember, don't use `shutdown` to restart the machine, because synced folders
will not be re-mounted. Instead use `vagrant reload`.
