# == Class: puppet:server::install
#
# This is will install and configure puppet-agent daemon
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
# Author Name: Rafael Sales <rafael@infinitecnologia.com.br>
#
# === Copyright
#
# Copyright 2018 Infini Tecnologia
#
class puppet::agent::install{
  package { 'puppet-agent':
    ensure => $::puppet::agent::version,
    name   => $::puppet::agent::package,
  }
}
