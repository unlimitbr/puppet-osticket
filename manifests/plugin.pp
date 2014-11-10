# lang.pp

define osticket::plugin ( 
  $source          = $osticket::params::ost_plugin_source,
  $ost_install_dir = $osticket::params::ost_install_dir, 
  ) {

  wget::fetch { "$name.phar":
    source => "${source}/$name.phar",
    destination => "${ost_install_dir}/include/plugins/$name.phar",
    require => Vcsrepo[$osticket::ost_install_dir],
  }
  
  if $name == "auth-ldap" {
    php::module{ "php5-ldap": }
  }

}
