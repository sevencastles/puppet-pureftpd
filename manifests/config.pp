# See README.md for options.
class pureftpd::config {

  # manage configuration files only if enabled
  if $pureftpd::config_manage {

    file { $pureftpd::config_dir:
      ensure  =>  directory,
      owner   =>  'root',
      group   =>  'root',
      mode    =>  '0755',
      recurse =>  $pureftpd::purge_conf_dir,
      purge   =>  $pureftpd::purge_conf_dir,
    }

    $attributes = $pureftpd::server_type ? {
      'postgres' => deep_merge($pureftpd::params::default_pgsql_config,
        $pureftpd::config),
      'mysql'    => deep_merge($pureftpd::params::default_mysql_config,
        $pureftpd::config),
      'ldap'     => deep_merge($pureftpd::params::default_ldap_config,
        $pureftpd::config),
      default    => deep_merge($pureftpd::params::default_config,
        $pureftpd::config)
    }

    $attributes.each |String $attribute, $value| {

      file {"${pureftpd::config_dir}/${attribute}":
        ensure  =>  file,
        content =>  "${value}\n",
        owner   =>  'root',
        group   =>  'root',
        mode    =>  '0644',
        require =>  File[$pureftpd::config_dir],
      }

      # only notify service if we're managing the service and
      # service restart is enabled.
      if $pureftpd::restart and $pureftpd::service_manage {
        File["${pureftpd::config_dir}/${attribute}"] {
          notify => Service['pureftpd']
        }
      }
    }

    file { $pureftpd::defaults_file:
      ensure  => file,
      content => template('pureftpd/defaults.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    file { $pureftpd::dir_aliases_file:
      ensure  =>  file,
      content =>  epp('pureftpd/pureftpd-dir-aliases.epp', {
        'config' =>  $pureftpd::dir_aliases
        }),
      owner   =>  'root',
      group   =>  'root',
      mode    =>  '0644',
    }

    file { $pureftpd::config_db_dir:
      ensure  =>  directory,
      owner   =>  'root',
      group   =>  'root',
      mode    =>  '0755',
      recurse =>  $pureftpd::purge_conf_dir,
      purge   =>  $pureftpd::purge_conf_dir,
    }

    # manage additional config files if not default server type
    case $pureftpd::server_type {
      'mysql': {
        file { "pureftpd-config-${pureftpd::server_type}":
          ensure  =>  file,
          path    =>  $pureftpd::mysql_config_file,
          content =>  epp('pureftpd/mysql.conf.epp', {
            'config' => deep_merge($pureftpd::params::mysqlconf_default,
              $pureftpd::mysql_config)
            }),
          owner   =>  'root',
          group   =>  'root',
          mode    =>  '0600',
          require =>  File[$pureftpd::config_db_dir],
        }
      }
      'postgres': {
        file { "pureftpd-config-${pureftpd::server_type}":
          ensure  =>  file,
          path    =>  $pureftpd::pgsql_config_file,
          content =>  epp('pureftpd/postgresql.conf.epp', {
            'config' =>  deep_merge($pureftpd::params::pgsqlconf_default,
              $pureftpd::pgsql_config)
            }),
          owner   =>  'root',
          group   =>  'root',
          mode    =>  '0600',
          require =>  File[$pureftpd::config_db_dir],
        }
      }
      'ldap': {
        file { "pureftpd-config-${pureftpd::server_type}":
          ensure  =>  file,
          path    =>  $pureftpd::ldap_config_file,
          content =>  epp('pureftpd/ldap.conf.epp', {
            'config' =>  deep_merge($pureftpd::params::ldapconf_default,
              $pureftpd::ldap_config)
            }),
          owner   =>  'root',
          group   =>  'root',
          mode    =>  '0600',
          require =>  File[$pureftpd::config_db_dir],
        }
      }
      default: { }
    }

    # only notify service if we're managing the service and
    # service restart is enabled.
    if $pureftpd::restart and $pureftpd::service_manage {
      File["pureftpd-config-${pureftpd::server_type}"] {
        notify => Service['pureftpd']
      }
      File[$pureftpd::dir_aliases_file] {
        notify => Service['pureftpd']
      }
      File[$pureftpd::defaults_file] {
        notify => Service['pureftpd']
      }

    }
  }

  # manage self-signed ssl certificate if enabled
  if $pureftpd::manage_ssl {

    $ssl_attributes = deep_merge($pureftpd::params::default_ssl,
      $pureftpd::ssl_config)

    openssl::certificate::x509 { 'pure-ftpd':
      ensure       => present,
      country      => $ssl_attributes[country],
      organization => $ssl_attributes[organization],
      commonname   => $ssl_attributes[commonname],
      days         => $ssl_attributes[days]
    }

    concat { $pureftpd::ssl_pemfile:
      owner => 'root',
      group => 'root',
      mode  => '0644'
    }

    concat::fragment { 'pureftpd-key':
      target => $pureftpd::ssl_pemfile,
      source => '/etc/ssl/certs/pure-ftpd.key',
      order  => '15'
    }

    concat::fragment{ 'pureftpd-cert':
      target => $pureftpd::ssl_pemfile,
      source => '/etc/ssl/certs/pure-ftpd.crt',
      order  => '30'
    }

    # only notify service if we're managing the service and
    # service restart is enabled.
    if $pureftpd::restart and $pureftpd::service_manage {
      Concat[$pureftpd::ssl_pemfile] {
        notify => Service['pureftpd']
      }
    }
  }
}
