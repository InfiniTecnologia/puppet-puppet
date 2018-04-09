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
      path    => '/etc/puppetlabs/puppet/autosign.conf',
      content => epp('puppet/autosign.conf.epp', {arr_autosign => $puppet::server::autosign}),
      notify  => Service[$puppet::server::service],
    }
  } else {
    file { 'puppet/autosign.conf':
      ensure => 'absent',
      path   => '/etc/puppetlabs/puppet/autosign.conf',
      notify => Service[$puppet::server::service],
    }
  }

  $puppet_config_defaults = lookup('puppet::server::puppet_config');
  $puppet_agent_config_defaults = lookup('puppet::puppet_config');

  $puppet_config = deep_merge(
    $puppet_config_defaults,
    $puppet_agent_config_defaults,
    $conf_autosign,
    $puppet::server::puppet_config_override_defaults
  )

  file {'puppet/puppet.conf':
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    content => epp('puppet/puppet.conf.epp', {puppet_config => $puppet_config}),
    mode    => '0644',
    notify  => Service[$puppet::server::service],
  }

  if $puppet::server::java_args != undef {
    augeas {'java_args':
      context => "${puppet::server::system_config_path}/puppetserver",
      changes => [ "set JAVA_ARGS '\"${puppet::server::java_args}\"'", ],
      notify  => Service[$puppet::server::service],
    }
  }

  @@host{ $facts['fqdn']:
    ip           => $facts['ipaddress'],
    host_aliases => [
      $facts['hostname'],
      "puppet.${facts['domain']}",
      puppet,
    ],
    tag          => ['puppetserver']
  }

}
