# == Class: puppet:agent
#
# This is will manage puppet-agent daemon
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
class puppet::agent(
  $version,
  $enable,
  $package,
  $service,
  $manage_service,
  ) {

  include puppet::agent::install

  #Class['puppet::server::install']

}
