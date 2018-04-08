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
  String                                      $version,
  String                                      $package,
  String                                      $service,
  Boolean                                     $manage_service,
  String                                      $system_config_path,
  Variant[String, Undef]                      $java_args = undef,
  Variant[Array[String, 1], Undef, Boolean]   $autosign = undef,
  Hash                                        $puppet_config_override_defaults = {},
) {

  include puppet::server::install
  include puppet::server::configure
  include puppet::server::service

  Class['puppet::server::install']
    -> Class['puppet::server::configure']
      ~> Class['puppet::server::service']

}
