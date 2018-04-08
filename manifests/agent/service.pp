# == Class: puppet:server::install
#
# This is will install and configure puppet-server daemon
# === Requirements
#
#
# === Parameters
#
#
# === Example
#
#
# === Authors
#
# Author Name: Raphael Neumann <raphael@infinitecnologia.com.br>
#
# === Copyright
#
# Copyright 2018 Infini Tecnologia
#
class puppet::agent::service{
  if $puppet::manage_service == true {
    service{$puppet::service:
      ensure    => 'running',
      enable    => true,
      subscribe => [
        File['puppet/puppet.conf'],
      ],
    }
  }
}
