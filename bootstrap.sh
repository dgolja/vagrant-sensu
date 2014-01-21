#!/bin/bash

echo "127.0.0.1 sensumaster.vagrant" >> /etc/hosts

if which puppet > /dev/null 2>&1; then
      echo 'Puppet Installed.'
    else
      echo 'Installing Puppet Client.'
      wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb
      dpkg -i puppetlabs-release-precise.deb
fi

apt-get update
apt-get -y install puppet
apt-get -y install git

puppet module install puppetlabs-stdlib
puppet module install puppetlabs-rabbitmq
# now some dirty work to get the last version from github
# due to ssl_verify parameter
cd /etc/puppet/modules
rm -rf rabbitmq
git clone https://github.com/puppetlabs/puppetlabs-rabbitmq.git rabbitmq
cd rabbitmq
# just make sure that the master is not broken by mistake
git checkout eb2ab911c7e4ca90d450baef4c8d578e24d2ba6f
puppet module install arioch/redis
puppet module install sensu-sensu

# generate sensu SSL certificates
cd /root
wget http://sensuapp.org/docs/0.12/tools/ssl_certs.tar
tar -xvf ssl_certs.tar
cd ssl_certs
./ssl_certs.sh generate
