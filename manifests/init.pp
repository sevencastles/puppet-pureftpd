# Class: pureftpd:  See README.md for documentation.
class pureftpd (
  Hash                        $config             = {},
  String                      $config_db_dir      = $pureftpd::params::config_db_dir,
  String                      $config_dir         = $pureftpd::params::config_dir,
  Boolean                     $config_manage      = $pureftpd::params::config_manage,
  Hash                        $dir_aliases        = {},
  String                      $dir_aliases_file   = $pureftpd::params::dir_aliases_file,
                              $install_options    = undef,
  Hash                        $ldap_config        = {},
  String                      $ldap_config_file   = $pureftpd::params::ldap_config_file,
  Boolean                     $manage_ssl         = $pureftpd::params::manage_ssl,
  Hash                        $mysql_config       = {},
  String                      $mysql_config_file  = $pureftpd::params::mysql_config_file,
  String                      $package_ensure     = $pureftpd::params::package_ensure,
  Boolean                     $package_manage     = $pureftpd::params::package_manage,
  String                      $package_name       = $pureftpd::params::package_name,
  String                      $package_name_ldap  = $pureftpd::params::package_name_ldap,
  String                      $package_name_mysql = $pureftpd::params::package_name_mysql,
  String                      $package_name_pgsql = $pureftpd::params::package_name_pgsql,
  Hash                        $pgsql_config       = {},
  String                      $pgsql_config_file  = $pureftpd::params::pgsql_config_file,
  Boolean                     $purge_conf_dir     = $pureftpd::params::purge_conf_dir,
  Boolean                     $restart            = $pureftpd::params::restart,
  String                      $server_mode        = $pureftpd::params::server_mode,
  String                      $server_type        = $pureftpd::params::server_type,
  Boolean                     $service_enabled    = $pureftpd::params::service_enabled,
  Boolean                     $service_manage     = $pureftpd::params::service_manage,
  String                      $service_name       = $pureftpd::params::service_name,
  String                      $service_name_ldap  = $pureftpd::params::service_name_ldap,
  String                      $service_name_mysql = $pureftpd::params::service_name_mysql,
  String                      $service_name_pgsql = $pureftpd::params::service_name_pgsql,
  String                      $service_provider   = $pureftpd::params::service_provider,
  Hash                        $ssl_config         = {},
  String                      $ssl_pemfile        = $pureftpd::params::ssl_pemfile,
  Variant[String, Integer] $uploadgid          = $pureftpd::params::uploadgid,
  Variant[String, Integer] $uploaduid          = $pureftpd::params::uploaduid,
  String                      $uploadscript       = $pureftpd::params::uploadscript,
  Boolean                     $virtualchroot      = $pureftpd::params::virtualchroot
) inherits pureftpd::params {

  if $manage_ssl {
    include '::openssl'
  }

  include '::pureftpd::install'
  include '::pureftpd::config'
  include '::pureftpd::service'

  Class[ 'pureftpd::install' ]
  -> Class[ 'pureftpd::config' ]
  -> Class[ 'pureftpd::service' ]

}
