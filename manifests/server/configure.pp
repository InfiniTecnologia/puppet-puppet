# == Class: puppet:server::configure
#
# This is will configure puppetserver
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
class puppet::server::configure{

  if $puppet::server::autsign == true {
    $conf_autosign = {
      'master' => {
        'autsign' => true
      }
    }
  }else{
    $conf_autosign = {}
  }

  $puppet_config1 = deep_merge($puppet::server::puppet_config, $conf_autosign)

  file {'puppet.conf':
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    content => epp('puppet/puppet.conf.epp', {puppet_config => $puppet_config}),
    mode    => '0644',
  }

  #augeas {'java_args':
  #  context => "${puppet::server::path_system_config}/puppetserver",
  #  changes => [ "set JAVA_ARGS '\"${puppetserver::java_args}\"'", ],
  #  notify  => Service['puppetserver']
  #}
}
