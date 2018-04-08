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
class puppet::agent::configure{

  $puppet_config_defaults = lookup('puppet::agent::puppet_config');
  $puppet_config = deep_merge($puppet_config_defaults, $puppet::agent::puppet_config_override_defaults)

  file {'puppet/puppet.conf':
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    content => epp('puppet/puppet.conf.epp', {puppet_config => $puppet_config}),
    mode    => '0644',
  }

}
