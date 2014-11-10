# lang.pp

define osticket::lang ( 
  $source          = $osticket::params::ost_lang_source,
  $ost_install_dir = $osticket::params::ost_install_dir, 
  ) {

  wget::fetch { "$name.phar":
    source => "${source}/$name.phar",
    destination => "${ost_install_dir}/include/i18n/$name.phar",
    require => Vcsrepo[$osticket::ost_install_dir],
  }

}
