# == Class: osticket
#
# This puppet module installs the opensource ticketing system osTicket.
# Additional information about osTicket can be found here.
# This software is provided asis so use at your own risk.
#
# === Variables
#
# Currently this Class consumes the following variables.
#
# [*ost_dir*]
#   The directory which contains the source code for osTicket
# [*ost_install_dir*]
#   The directory where osTicket will be installed into
# [*ost_db_user*]
#  The username used for the osTicket database connections
# [*ost_db_password*]
#   The password used to authenticate the ost_db_user to the osTicket database
# [*ost_db_name*]
#   The name of the database osTicket will connect to.
# [*ost_db_host*]
#   The host running the osTicket database instance
# [*ost_version*]
#   The version of the osTicket being installed.
# [*ost_langs*]
#   Array of language packs to be installed.
# [*ost_plugins*]
#   Array of plugins to be installed.
#
# === Examples
#
#  class { osticket: }
#
# === Authors
#
# Author Name <peter@pouliot.net>
#
# === Copyright
#
# Copyright 2014 Peter J. Pouliot <peter@pouliot.net>, unless otherwise noted.
#
class osticket (
  $ost_install_dir = $osticket::params::ost_install_dir,
  $ost_db_name     = $osticket::params::ost_db_name,
  $ost_db_user     = $osticket::params::ost_db_user,
  $ost_db_passwd   = $osticket::params::ost_db_passwd,
  $ost_db_host     = $osticket::params::ost_db_host,
  $ost_version     = $osticket::params::ost_version,
  $ost_src_url     = $osticket::params::ost_src_url,
  $osticket_admin  = $osticket::params::ost_admin_email,
  $ost_langs       = [],
  $ost_plugins     = [],
) inherits params {

  ensure_resource('php::module', ['imap','gd','mysql'] )
  
  exec {'enable-php5-imap':
    command     => '/usr/sbin/php5enmod imap',
    unless      => '/usr/sbin/php5query -M |grep imap',
    refreshonly => true,
    subscribe   => Php::Module['imap'],
  }
  
  if !defined(Class['apache']) {
    class{'apache':
      default_vhost  => true,
      mpm_module     => prefork,
      service_enable => true,
      service_ensure => running,
    }
  }
  if !defined(Class['apache::mod::php']){
    class {'apache::mod::php':}
  } 

  apache::vhost {'osTicket':
    priority   => '10',
    vhost_name => $::ipaddress,
    port       => 80,
    docroot    => $ost_install_dir,
    logroot    => "/var/log/${module_name}",
    require    => Vcsrepo[$ost_install_dir],
  }

  if $ost_db_host == 'localhost' {
    class { 'osticket::database::mysql':
      ensure => 'present',
      host => 'localhost',
      password_hash => mysql_password("${dbpass}"),
      user => $dbuser,
      dbname => $dbname,
    }
  }

  # Clone osticket repo
  ensure_packages("git")
  vcsrepo { $ost_install_dir:
    ensure   => present,
    provider => git,
    source   => $ost_src_url,
    revision => "v${ost_version}",
    require  => Package[['php5-gd', 'git']],
    owner    => 'www-data',
    group    => 'www-data',
  }

  # Install language packs     
  osticket::lang { $ost_langs:
    ost_install_dir => $ost_install_dir,
  }

  # Install plugins
  osticket::plugin { $ost_plugins:
    ost_install_dir => $ost_install_dir,
  }
}
