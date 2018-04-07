# == Class: puppet:server
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
class puppet::agent(
  $version,
  $enable,
  $package,
  $service,
  $manage_service,
  $puppet_config_override_defaults,
  $autosign = undef,
  ) {

  include puppet::agent::install
  include puppet::agent::configure

  Class['puppet::agent::install']
    ->Class['puppet::agent::configure']

}
