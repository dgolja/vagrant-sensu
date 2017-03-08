#!/bin/bash

echo "127.0.0.1 sensumaster.vagrant" >> /etc/hosts

if which puppet > /dev/null 2>&1; then
  echo 'Puppet Installed.'
else
  echo 'Installing Puppet Client.'
  wget http://apt.puppetlabs.com/puppetlabs-release-trusty.deb
  dpkg -i puppetlabs-release-trusty.deb
fi

apt-get update
apt-get -y install puppet
apt-get -y install git
apt-get -y install ruby-dev

gem install --no-ri --no-rdoc r10k
cd /etc/puppet
rm -rf modules/

LIBRARIAN_FILE=$( cat << EOF
forge "http://forge.puppetlabs.com"

mod "arioch/redis", "1.1.3"
mod "sensu/sensu", "2.0.0"
mod "puppetlabs/stdlib"
mod "puppetlabs/apt"
mod "maestrodev/wget"
mod "garethr/erlang", "0.3.0"
mod "puppetlabs/rabbitmq", "5.3.1"
mod "nanliu/staging"
mod "yelp/uchiwa", "0.3.0"

EOF
)

echo "${LIBRARIAN_FILE}" > /etc/puppet/Puppetfile
r10k puppetfile install -v

# warnings sux
sed -i '/^templatedir/d' /etc/puppet/puppet.conf

# generate sensu SSL certificates to the puppet manifest can use them
cd /root
wget https://sensuapp.org/docs/latest/tools/ssl_certs.tar
tar -xvf ssl_certs.tar
cd ssl_certs
./ssl_certs.sh generate
