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
        git clone git@github.com:Vinietskyzilla/vagrant_rails.git
        cd vagrant_rails/vagrant
        vagrant up

2. `vagrant up` will take a while the first time. Come back in 10 or 20 minutes.

3. When `vagrant up` is complete, visit [http://localhost:4568](http://localhost:4568).

4. Try `vagrant ssh`:

        # cd back to the vagrant directory if you're not there already.
        cd vagrant_rails/vagrant
        vagrant ssh

## How to restart the machine

Remember, do NOT use the `shutdown` command to restart the machine, because synced folders will not be re-mounted. Instead use `vagrant reload`.

## Developing Rails

There is an example Rails app in vagrant_rails/vagrant/rails but you will probably want to try building a new app.

Delete the existing app.

        cd vagrant_rails/vagrant
        rm -r rails

Now you have a couple choices. You can create a new rails directory and put your app there

        cd vagrant_rails/vagrant
        mkdir rails

Or you can create your rails app somewhere else and symlink it.

        cd vagrant_rails/vagrant
        ln -s /path/to/your/rails_app rails

Next you need to ssh into the server, create a gemset, and install your gems.

        cd vagrant_rails/vagrant
        vagrant ssh
        # The Rails app and RVM are owned by the www-data user.
        # `-l` and `-s /bin/bash` help get RVM and other environment stuff set up.
        sudo su -l www-data -s /bin/bash
        # Optional: get a better prompt.
        bash --login
        cd /var/www/rails
        rvm use --create @your_new_gemset
        # New to Rails? See http://guides.rubyonrails.org/getting_started.html
        gem install rails
        rails new blog
        echo "gem 'puma'" > Gemfile
        bundle install
        bundle exec puma
        
(If there is a complaint that the port is already taken, then follow the directions under "How to kill the Puma daemon process" below.)

After that you can hack away on the Rails app files from your local machine. If you change the `rails/config` files, then restart Puma and Apache, in that order. (Eventually I will make that simpler.)

## Run Puma

### In development mode 

`bundle exec puma`

### In production mode

`bundle exec puma --production`

### As a daemon

`bundle exec puma -d`

**How to kill the Puma daemon process**

Find puma's PID with `ps axu | grep -v grep | grep puma`. Stop the daemon with `kill PID`. (If you don't know what `kill` is then read `man kill` first.) (Coming soon: this is easier with pumactl and a puma config file.)

## Restart Apache

Make sure you are the `vagrant` user, not the `www-data` user, so that you can use `sudo`. You can find out which user you are using `whoami`. Then do `sudo service apache2 restart`. You shouldn't need to do this unless Apache config, enabled sites, or enabled modules are changed.
