# == Class: osticket::params
# This class controls the default ost settings
#

class osticket::params {
  $ost_install_dir     = '/var/www/html/support'
  $ost_db_name         = 'osticket'
  $ost_db_user         = 'osticket'
  $ost_db_passwd       = 'osticket'
  $ost_db_host         = 'localhost'
  $ost_version         = '1.9.4'
  $ost_src_url         = "https://github.com/osTicket/osTicket-1.8"
  $ost_admin_email     = "root@${::fqdn}"
  $ost_lang_source     = "http://osticket.com/sites/default/files/download/lang/"
  $ost_plugin_source   = "http://osticket.com/sites/default/files/download/plugin-edge/"
}
