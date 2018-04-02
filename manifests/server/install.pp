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
class puppet::server::install{
  package { 'puppetserver':
    ensure => $::puppet::server::version,
    name   => $::puppet::server::package,
  }
}
