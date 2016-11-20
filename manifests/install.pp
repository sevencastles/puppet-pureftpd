# See README.md for options.
class pureftpd::install {

  if $pureftpd::package_manage {

    $real_package_name = $pureftpd::server_type ? {
      'postgres'  => $pureftpd::package_name_pgsql,
      'mysql'     => $pureftpd::package_name_mysql,
      'ldap'      => $pureftpd::package_name_ldap,
      default     => $pureftpd::package_name
    }

    package { 'pureftpd-server':
      ensure          => $pureftpd::package_ensure,
      install_options => $pureftpd::install_options,
      name            => $real_package_name,
    }
  }
}
