This project uses Rails, Puma, Rubinius, RVM, Apache, Ubuntu, VirtualBox, and Vagrant.

##Setup

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (preferably version 4.3.26 or greater).
- Install [Vagrant](http://www.vagrantup.com/downloads.html).
- `git clone git@github.com:Vinietskyzilla/vagrant_rails.git`
- `cd vagrant_rails/vagrant/`
- `vagrant plugin install vagrant-vbguest`
- Set up the VBoxGuestAdditions.iso file.
  - This is done just to make sure that the iso is not downloaded again after every `vagrant destroy; vagrant up`.
  - Download http://download.virtualbox.org/virtualbox/**YOUR_VBOX_VERSION**/VBoxGuestAdditions_**YOUR_VBOX_VERSION**.iso and put it in `vagrant_rails`
  - Update `config.vbguest.iso_path` in Vagrantfile to point to the VBoxGuestAdditions_**YOUR_VBOX_VERSION**.iso you downloaded.
  - Alternatively, delete `config.vbguest.iso_path` and follow these directions to set up a default iso: [https://github.com/dotless-de/vagrant-vbguest/#iso-autodetection](https://github.com/dotless-de/vagrant-vbguest/#iso-autodetection)
- `vagrant up`!

## How to restart the machine
Remember, don't use `shutdown` (while ssh'd into the machine) to restart the machine, because synced folders will not be re-mounted. Instead use `vagrant reload`.