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
class puppet::server(
  $version,
  $enable,
  $package,
  $service,
  $manage_service,
  $puppet_config,
  $autosign = undef,
  ) {

  include puppet::server::install
  include puppet::server::configure

  Class['puppet::server::install']
    ->Class['puppet::server::configure']

}
