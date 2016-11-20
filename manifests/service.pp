# See README.md for options.
class pureftpd::service {

  if $pureftpd::service_manage {

    $service_ensure = $pureftpd::service_enabled ? {
      true  =>  'running',
      false =>  'stopped'
    }

    $real_service_name = $pureftpd::server_type ? {
      'postgres'  => $pureftpd::service_name_pgsql,
      'mysql'     => $pureftpd::service_name_mysql,
      'ldap'      => $pureftpd::service_name_ldap,
      default     => $pureftpd::service_name
    }

    service { 'pureftpd':
      ensure   => $service_ensure,
      name     => $real_service_name,
      enable   => $pureftpd::real_service_enabled,
      provider => $pureftpd::service_provider,
    }

    # only establish ordering between service and package if
    # we're managing the package.
    if $pureftpd::package_manage {
      Service['pureftpd'] {
        require  => Package['pureftpd-server'],
      }
    }

    # only establish ordering between config file and service if
    # we're managing the config file.
    if $pureftpd::manage_config {
      File[$pureftpd::config_db_dir] -> Service['pureftpd']
      File[$pureftpd::config_dir] -> Service['pureftpd']
      File[$pureftpd::defaults_file] -> Service['pureftpd']
      File[$pureftpd::dir_aliases_file] -> Service['pureftpd']
    }
  }
}
