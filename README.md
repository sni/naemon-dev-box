# Naemon Dev Box

## Content

  - OMD Labs Edition
    - include mon site with prometheus monitoring and grafana dashboard
    - include dev site with Naemon-core from git clone

## Usage

You will need `vagrant` and `virtualbox`.

    %> git clone git@github.com:sni/naemon-dev-vagrant-box.git
    %> cd naemon-dev-vagrant-box
    %> vagrant plugin install vagrant-vbguest
    %> vagrant up
    %> vagrant ssh

### OMD

There is a mon site created with the default omdadmin/omd user at:

https://192.168.99.99/mon/

This site is intented to monitor the dev site.

A site named dev will also be created which runs the Naemon-core with some
example checks.

### Development

Naemon-core and Naemon-Livestatus will be cloned to /vagrant and the dev
OMD site will be prepared to use those files.

#### Build
Naemon and Naemon-Livestatus need to be build inside the vagrant box:


    [root@naemon-dev ~]# cd /vagrant/naemon-core && ./autogen.sh && ./configure && make
    [root@naemon-dev ~]# cd /vagrant/naemon-livestatus && autoreconf -i && PKG_CONFIG_PATH=../naemon-core ./configure && make

## Provisioning

The initial provisioning is done by a shell command which installs omd and the
repositories. Everything else is provisioned by ansible. You can rerun the
provisioning anytime by running this as root:

    #> bash /vagrant/provision/ansible.sh
