# Run Rails on Vagrant

This project launches a Rails app in a virtual machine running on the local machine using Vagrant, VirtualBox, Puma, Apache, Rubinius, RVM, and Ubuntu.

Eventually the aim is for it to be fully production ready, but first there are some things left to do, like fully setting up SSL/TLS.

I don't have much experience with Puma or Rubinius yet. Currently Puma is proxied through Apache, but it's possible Puma might run fine all on its own in production, I don't know yet.

## Requirements

### All Operating Systems

Install [Vagrant](http://www.vagrantup.com/downloads.html), [VirtualBox](https://www.virtualbox.org/wiki/Downloads), and [Git](http://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

### Extra requirements for Windows

The instructions below probably won't work in Windows' normal command prompt (they might! I'm not sure), but they should work in [this Git shell](https://msysgit.github.io/), [this other Git shell](https://windows.github.com/), or [Cygwin](https://www.cygwin.com/).

## Setup

1. Open a shell (i.e. Terminal, Cygwin, or whatever):

        vagrant plugin install vagrant-vbguest
        git clone git@github.com:dcki/vagrant_rails.git
        cd vagrant_rails/vagrant
        vagrant up

2. `vagrant up` will take a while the first time. Come back in 10 or 20 minutes.

3. When `vagrant up` is complete, visit [http://localhost:4568](http://localhost:4568).

4. Try `vagrant ssh`:

        # cd back to the vagrant directory if you're not there already.
        cd vagrant_rails/vagrant
        vagrant ssh

### Troubleshooting

Sometimes something goes wrong during the installation process (e.g. gpg can't find a key and subsequently RVM doesn't install). If this happens it should be safe and may help to `vagrant reload --provision`. If something is still broken you can try fixing it (reading `vagrant_rails/vagrant/bootstrap/bootstrap.sh` might help) or completely start over using `vagrant destroy; vagrant up`.

If installation succeeded but things are still not working, then

- Check if you are viewing https://localhost:4568. SSL is not currently enabled so https will not work. Some Rails apps redirect the client to https. You can enable SSL by `ln -s /vagrant/apache/ssl /etc/apache2/sites-available; sudo a2ensite ssl`, but be aware it is not configured securely for use in a public facing, production system.
- Currently Apache and Puma will not start automatically after restarting the VM with `vagrant reload`.
  - Check `sudo service apache2 status`. If Apache is not running, `sudo service apache2 restart`. For more information see _How to restart Apache_ below.
  - Check `sudo vpuma status`. If Puma is not running, `sudo vpuma restart`. For more information see _How to restart Puma_ below.

## How to restart the machine

Remember, do NOT use the `shutdown` command to restart the machine, because synced folders will not be re-mounted. Instead use `vagrant reload`.

## Developing Rails

There is an example Rails app in `vagrant_rails/vagrant/rails` but you will probably want to try building a new app.

### Set up a new Rails app inside the VM

If you don't have a Rails app yet, you can create one inside the VM. (Make sure you follow the _Setup_ instructions above first, to get the VM running.)

First, delete the existing app.

        cd vagrant_rails/vagrant
        rm -r rails
        mkdir rails

ssh into the server, create a gemset, and install your gems.

        cd vagrant_rails/vagrant
        vagrant ssh
        # The Rails app and RVM are owned by the www-data user.
        # `-l` and `-s /bin/bash` help get RVM and other environment stuff set up.
        sudo su -l www-data -s /bin/bash
        # Optional: get a better prompt.
        bash --login
        cd /var/www/rails
        gem install rails
        rails new blog

(New to Rails? See the [Getting Started with Rails](http://guides.rubyonrails.org/getting_started.html) guide.)

Now follow the _Manual setup_ instructions below to finish setting up your new Rails app.

### Import an existing Rails app

If you already have Rails app that you want to run inside the VM, do this:

First, delete the existing app.

        cd vagrant_rails/vagrant
        rm -r rails

Now you have a couple choices. You can move your existing app into `vagrant_rails/vagrant/rails`:

        cd vagrant_rails/vagrant
        mv /path/to/your/rails_app rails

Or you can create your rails app somewhere else and symlink it.

        cd vagrant_rails/vagrant
        ln -s /path/to/your/rails_app rails

Now you can either start a brand new Vagrant VM and have all the setup handled for you, with `vagrant destroy; vagrant up` (`vagrant reload --provision` might also work), OR if you want to set things up manually, follow _Manual setup_:

### Manual setup

Setting up your Rails app in the VM manually requires that the VM is already running. You can check that with

        cd vagrant_rails/vagrant
        vagrant status

If the VM is not yet provisioned and your app is already in the `vagrant_rails/vagrant/rails` directory, then your app should be set up automatically when you `vagrant up`. (So if `vagrant status` says "not created" then go ahead and `vagrant up` now.) If the VM _is_ already running but you want to skip manual setup, then just do `vagrant destroy; vagrant up` (`vagrant reload --provision` might also work) and your app will be setup automatically. Otherwise, continue:

Now that you have a Gemfile you're ready to install all the other gems your Rails app needs.

        cd vagrant_rails/vagrant
        vagrant ssh
        cd /var/www/rails
        sudo su -l www-data -s /bin/bash
        bash --login
        # Add the puma gem to your Gemfile.
        echo "gem 'puma'" >> Gemfile
        # Check if the bundler gem is installed.
        gem list bundler
        # If bundler is not installed, install it.
        gem install bundler
        # Install your app's gems.
        bundle install
        # Set up the Rails production mode secret key
        /vagrant/bootstrap/www-data/add_secret_key.sh

Finally, in another shell, restart Puma:

        cd vagrant_rails/vagrant
        vagrant ssh
        sudo vpuma restart development

After that you can hack away on the Rails app files from your local machine.

## How to restart Puma

If you change the `rails/config` files or install new gems, then Puma will need to be restarted.

A Puma config file (`/var/www/puma_config.rb`) and a script called `vpuma` are provided to make controlling Puma simpler.

Usage for `vpuma` is `sudo vpuma [<command> [<mode>]]`. `mode` is `development` by default. `sudo vpuma` (with no command) lists available Puma commands.

Make sure you are the `vagrant` user, not the `www-data` user, so that you can use `sudo`. You can find out which user you are using `whoami`.

### Rails modes and Puma

Keep in mind that if Puma is already running in `production` mode and you `sudo vpuma restart development`, then Puma will silently fail to restart and leave the original process running, and your Rails config and gem updates will not take effect. (The same happens in reverse, if Puma is already running in development mode and you try to start it in production mode.)

You can use `ps axu | grep -v grep | grep puma` to find out if Puma is already running, and if it is then

        sudo vpuma status development
        sudo vpuma status production

to find out which mode Puma is running in.

If you need to switch from production to development mode, you would

        sudo vpuma stop production
        sudo vpuma start development

In some cases, if all of the above fails, you may need to `kill PID`, where PID is the first number from `ps axu | grep -v grep | grep puma`. (`vpuma` finds running Puma processes using information from the files in `/var/www/rails/tmp/pids/`, so if those files are deleted after a Puma process is started, then `vpuma` will not be able to help stop them, and that's when you will need to use `kill`.)

## How to restart Apache

Make sure you are the `vagrant` user so that you can use `sudo`. Then do `sudo service apache2 restart`. You shouldn't need to do this unless Apache config, enabled sites, or enabled modules are changed.
