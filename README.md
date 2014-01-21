# Vagrant Sensu Development VM

## About

This vagrant configuration will boot up a working [Sensu](https://github.com/sensu/sensu) server to facilities development/testing.

## Requirements

  * [Vagrant](http://www.vagrantup.com/) - Recommended version 1.4.X
  * [VirtualBox](https://www.virtualbox.org/) - Recommended version 4.3.X
  * Internet access :))

## Installation

Clone repository

```$ git clone https://github.com/n1tr0g/vagrant-sensu.git```

Start image

```vagrant up```

Start the services you need

```$ vagrant ssh
$ service sensu-server start
$ servic sensu-api start
$ service sensu-dashboard start
$ service sensu-client start
```

For example to access the sensu dashboard type http://localhost:8080/

## License

Apache License Version 2.0
