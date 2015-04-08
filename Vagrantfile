# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version.
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. To see more configuration examples
  # you can create a new directory somewhere and execute `vagrant init` to get
  # a new Vagrantfile that includes more configuration examples. For a complete
  # reference, see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "hashicorp/precise32"

  # By default Vagrant mounts the same directory, but this line makes
  # permissions slightly more restrictive by not allowing users outside the
  # vagrant user or vagrant group to read these files.
  config.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=755", "fmode=640"]

  config.vm.provision :shell, path: "bootstrap.sh"

  config.vm.network :forwarded_port, host: 4567, guest: 80

  # You might also consider using CFEngine, Puppet, Chef, or similar.
end
