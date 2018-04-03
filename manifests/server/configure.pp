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
  augeas {'puppet.conf':
    context => '/files/etc/puppetlabs/puppet/puppet.conf',
    changes => [
      "set main/certname ${puppet::server::certname}",
      "set main/server ${puppet::server::certname}",
      "set master/autosign ${puppet::server::autosign}",
    ],
    notify  => Service['puppetserver']
  }
  if(is_hash($puppet::server::server_configs) ){

    $puppet::server::server_configs.each |String $setting, String $value|{
      augeas {'puppet.conf':
        context => '/files/etc/puppetlabs/puppet/puppet.conf/master',
        changes => ["set ${$setting} ${value}",],
        notify  => Service['puppetserver']
      }
    }
  }

  augeas {'java_args':
    context => "${puppet::server::path_system_config}/puppetserver",
    changes => [ "set JAVA_ARGS '\"${puppetserver::java_args}\"'", ],
    notify  => Service['puppetserver']
  }
}
