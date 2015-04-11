# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version.
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. To see more configuration examples
  # you can create a new directory somewhere and execute `vagrant init` to get
  # a new Vagrantfile that includes more configuration examples. For a complete
  # reference, see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  # TODO I think I can permanently update the VirtualBox guest additions if I
  # make a copy of this box and update the box. Or maybe there is a newer
  # version of this box that I can download.
  # TODO It might also be possible and a good idea to move some or most of
  # bootstrap.sh to executed setup on the box so that the first vagrant up
  # doesn't take so long. Although this might be a bad idea because then
  # having full control over what goes on the machine is diminished, or if
  # modifications are needed the box will have to be modified too which may be
  # more complicated than just modifying the setup config and scripts.
  # TODO Try hashicorp/precise64.
  config.vm.box = 'hashicorp/precise32'

  # Use pre-downloaded VBoxGuestAdditions iso to save time during vagrant up.
  # Downloaded from http://download.virtualbox.org/virtualbox/4.3.26/VBoxGuestAdditions_4.3.26.iso
  config.vbguest.iso_path = '../VBoxGuestAdditions_4.3.26.iso'

  # "mount_options: ['dmode=755', 'fmode=640']" makes permissions slightly more
  # restrictive by not allowing other users or groups to read these files.
  # TODO I think dmode=755 is the default and can be omitted.
  config.vm.synced_folder(
    'apache', '/vagrant/apache',
    owner: 'root', group: 'root',
    mount_options: ['dmode=755', 'fmode=640']
  )
  # Note: /var/www is www-data's home folder.
  # Unfortunately we can't just mount the home folder because then weird issues
  # happen (like gpg being unable to create a lock when adding the key to verify
  # RVM), at least with VirtualBox shared folders. Might work on other providers.
  config.vm.synced_folder(
    'rails', '/var/www/rails',
    owner: 'www-data', group: 'www-data',
    mount_options: ['dmode=755', 'fmode=640']
  )
  config.vm.synced_folder(
    'bootstrap', '/vagrant/bootstrap',
    owner: 'root', group: 'root',
    mount_options: ['dmode=755', 'fmode=740']
  )
  config.vm.synced_folder(
    'bootstrap/execute_as_www-data', '/vagrant/bootstrap/execute_as_www-data',
    owner: 'www-data', group: 'www-data',
    mount_options: ['dmode=755', 'fmode=740']
  )

  # You might consider using CFEngine, Puppet, Chef, or similar instead of
  # shell scripts.
  config.vm.provision :shell, path: 'bootstrap/bootstrap.sh'

  # To learn how to run on ports 80 and 443, see http://www.dmuth.org/node/1404/web-development-port-80-and-443-vagrant
  config.vm.network :forwarded_port, host: 4568, guest: 80
end
