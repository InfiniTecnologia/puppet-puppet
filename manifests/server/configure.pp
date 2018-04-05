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


  if $puppet::server::autosign =~ Boolean {
    $conf_autosign = {
      'master' => {
        'autosign' => $puppet::server::autosign
      }
    }
  } else {
    $conf_autosign = {}
  }

  if $puppet::server::autosign =~ Array {
    file {'puppet/autosign.conf':
      path => '/etc/puppetlabs/puppet/autosign.conf',
      content => epp('puppet/autosign.conf.epp', {arr_autosign => $puppet::server::autosign}),
    }
  }

  $puppet_config = deep_merge($puppet::server::puppet_config, $conf_autosign)

  file {'puppet/puppet.conf':
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
