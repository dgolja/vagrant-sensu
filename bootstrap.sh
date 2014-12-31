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
apt-get -y install ruby-dev
apt-get -y install rubygems

gem install --no-ri --no-rdoc r10k
cd /etc/puppet
rm -rf modules/

LIBRARIAN_FILE=$( cat << EOF
forge "http://forge.puppetlabs.com"

mod "arioch/redis", "1.0.1"
mod "sensu/sensu", "1.3.1"
mod "puppetlabs/stdlib"
mod "puppetlabs/apt"
mod "maestrodev/wget"
mod "garethr/erlang", "0.3.0"
mod "puppetlabs/rabbitmq", "4.1.0"
mod "nanliu/staging"
mod "yelp/uchiwa", :git => "https://github.com/Yelp/puppet-uchiwa.git"

EOF
)

echo "${LIBRARIAN_FILE}" > /etc/puppet/Puppetfile
r10k puppetfile install -v

# warnings sux
sed -i '/^templatedir/d' /etc/puppet/puppet.conf

# generate sensu SSL certificates to the puppet manifest can use them
cd /root
wget http://sensuapp.org/docs/0.16/tools/ssl_certs.tar
tar -xvf ssl_certs.tar
cd ssl_certs
./ssl_certs.sh generate
