# Class: pureftpd:  See README.md for documentation.
class pureftpd (
  $config             = {},
  $config_db_dir      = $pureftpd::params::config_db_dir,
  $config_dir         = $pureftpd::params::config_dir,
  $config_manage      = $pureftpd::params::config_manage,
  $dir_aliases        = {},
  $dir_aliases_file   = $pureftpd::params::dir_aliases_file,
  $install_options    = undef,
  $ldap_config        = {},
  $ldap_config_file   = $pureftpd::params::ldap_config_file,
  $manage_ssl         = $pureftpd::params::manage_ssl,
  $mysql_config       = {},
  $mysql_config_file  = $pureftpd::params::mysql_config_file,
  $package_ensure     = $pureftpd::params::package_ensure,
  $package_manage     = $pureftpd::params::package_manage,
  $package_name       = $pureftpd::params::package_name,
  $package_name_ldap  = $pureftpd::params::package_name_ldap,
  $package_name_mysql = $pureftpd::params::package_name_mysql,
  $package_name_pgsql = $pureftpd::params::package_name_pgsql,
  $pgsql_config       = {},
  $pgsql_config_file  = $pureftpd::params::pgsql_config_file,
  $purge_conf_dir     = $pureftpd::params::purge_conf_dir,
  $restart            = $pureftpd::params::restart,
  $server_mode        = $pureftpd::params::server_mode,
  $server_type        = $pureftpd::params::server_type,
  $service_enabled    = $pureftpd::params::service_enabled,
  $service_manage     = $pureftpd::params::service_manage,
  $service_name       = $pureftpd::params::service_name,
  $service_name_ldap  = $pureftpd::params::service_name_ldap,
  $service_name_mysql = $pureftpd::params::serivce_name_mysql,
  $service_name_pgsql = $pureftpd::params::serivce_name_pgsql,
  $service_provider   = $pureftpd::params::service_provider,
  $ssl_config         = {},
  $ssl_pemfile        = $pureftpd::params::ssl_pemfile,
  $uploadgid          = $pureftpd::params::uploadgid,
  $uploaduid          = $pureftpd::params::uploaduid,
  $uploadscript       = $pureftpd::params::uploadscript,
  $virtualchroot      = $pureftpd::params::virtualchroot
) inherits pureftpd::params {

  validate_bool($config_manage, $manage_ssl, $package_manage, $restart)
  validate_bool($purge_conf_dir, $service_enabled, $service_manage)
  validate_hash($config, $dir_aliases,$ldap_config, $mysql_config)
  validate_hash($pgsql_config, $ssl_config)
  validate_string($config_db_dir, $config_dir, $dir_aliases_file)
  validate_string($ldap_config_file, $mysql_config_file, $package_ensure)
  validate_string($package_name, $package_name_ldap, $package_name_mysql)
  validate_string($package_name_pgsql, $pgsql_config_file, $server_mode)
  validate_string($server_type, $service_name, $service_provider, $ssl_pemfile)
  validate_string($uploadgid, $uploaduid, $uploadscript)

  if $manage_ssl {
    include '::openssl'
  }

  include '::pureftpd::install'
  include '::pureftpd::config'
  include '::pureftpd::service'

  Class[ 'pureftpd::install' ] ->
  Class[ 'pureftpd::config' ] ->
  Class[ 'pureftpd::service' ]

}
