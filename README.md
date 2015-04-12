This project uses Rails, Puma, Rubinius, RVM, Apache, Ubuntu, VirtualBox, and Vagrant.

##Setup

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads).
2. Install [Vagrant](http://www.vagrantup.com/downloads.html).
3.

        vagrant plugin install vagrant-vbguest
        git clone git@github.com:Vinietskyzilla/vagrant_rails.git
        cd vagrant_rails/vagrant
        vagrant up

## How to restart the machine
Remember, do NOT use the `shutdown` command to restart the machine, because synced folders will not be re-mounted. Instead use `vagrant reload`.