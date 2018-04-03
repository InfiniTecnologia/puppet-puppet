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
  ) {

  include puppet::server::install

  #Class['puppet::server::install']

}
