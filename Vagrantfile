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
  # doesn't take so long.
  config.vm.box = 'hashicorp/precise32'

  # "mount_options: ['dmode=755', 'fmode=640']" makes permissions slightly more
  # restrictive by not allowing other users or groups to read these files.
  config.vm.synced_folder 'bootstrap/ruby_user', '/vagrant/bootstrap/ruby_user', owner: 'ruby', group: 'ruby', mount_options: ['dmode=755', 'fmode=640']
  config.vm.synced_folder 'apache', '/vagrant/apache', mount_options: ['dmode=755', 'fmode=640']
  config.vm.synced_folder 'home', '/vagrant/home', mount_options: ['dmode=755', 'fmode=640']
  config.vm.synced_folder 'rails', '/var/www/rails', owner: 'ruby', group: 'ruby', mount_options: ['dmode=755', 'fmode=640']

  # You might consider using CFEngine, Puppet, Chef, or similar instead of
  # shell scripts.
  config.vm.provision :shell, path: 'bootstrap/bootstrap.sh'

  # To learn how to run on ports 80 and 443, see http://www.dmuth.org/node/1404/web-development-port-80-and-443-vagrant
  config.vm.network :forwarded_port, host: 4568, guest: 80
end
