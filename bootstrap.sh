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
apt-get -y install rubygems

gem install librarian-puppet
cd /etc/puppet
rm -rf modules/

LIBRARIAN_FILE=$( cat << EOF
forge "http://forge.puppetlabs.com"

mod "arioch/redis"
mod "sensu/sensu", "1.0.0"

mod "rabbitmq",
  :git => "https://github.com/puppetlabs/puppetlabs-rabbitmq.git",
  :ref => "eb2ab911c7e4ca90d450baef4c8d578e24d2ba6f"
EOF
)

echo "${LIBRARIAN_FILE}" > /etc/puppet/Puppetfile
librarian-puppet install

# generate sensu SSL certificates to the puppet manifest can use them
cd /root
wget http://sensuapp.org/docs/0.12/tools/ssl_certs.tar
tar -xvf ssl_certs.tar
cd ssl_certs
./ssl_certs.sh generate
