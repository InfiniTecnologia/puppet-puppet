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
  String                                      $version,
  String                                      $package,
  String                                      $service,
  Boolean                                     $manage_service,
  Hash                                        $puppet_config_override_defaults = {},
  ) {

  include puppet::agent::install
  include puppet::agent::configure

  Class['puppet::agent::install']
    ->Class['puppet::agent::configure']

}
