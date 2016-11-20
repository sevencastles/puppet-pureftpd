# Private class: See README.md.
class pureftpd::params {

  $config_manage   = true
  $manage_ssl      = false
  $package_ensure  = 'present'
  $package_manage  = true
  $purge_conf_dir  = true
  $restart         = true
  $server_mode     = 'standalone'
  $server_type     = 'default'
  $service_enabled = true
  $service_manage  = true
  $uploadgid       = ''
  $uploaduid       = ''
  $uploadscript    = ''
  $virtualchroot   = false

  case $::osfamily {
    'Debian': {
      $config_db_dir      = '/etc/pure-ftpd/db'
      $config_dir         = '/etc/pure-ftpd/conf'
      $defaults_file      = '/etc/default/pure-ftpd-common'
      $dir_aliases_file   = '/etc/pure-ftpd/pureftpd-dir-aliases'
      $ldap_config_file   = '/etc/pure-ftpd/db/ldap.conf'
      $mysql_config_file  = '/etc/pure-ftpd/db/mysql.conf'
      $package_name       = 'pure-ftpd'
      $package_name_mysql = 'pure-ftpd-mysql'
      $package_name_ldap  = 'pure-ftpd-ldap'
      $package_name_pgsql = 'pure-ftpd-postgresql'
      $pgsql_config_file  = '/etc/pure-ftpd/db/postgresql.conf'
      $service_name       = 'pure-ftpd'
      $service_name_ldap  = 'pure-ftpd-ldap'
      $serivce_name_mysql = 'pure-ftpd-mysql'
      $service_name_pgsql = 'pure-ftpd-postgresql'
      $service_provider   = 'systemd'
      $ssl_pemfile        = '/etc/ssl/private/pure-ftpd.pem'
    }

    default: {
      fail("Unsupported platform: bkuebler-${module_name} currently doesn't support ${::osfamily} or ${::operatingsystem}")
    }

  }

  # default hash section begins here
  $default_config = {
    'AltLog'             => 'clf:/var/log/pure-ftpd/transfer.log',
    'FSCharset'          => 'UTF-8',
    'MinUID'             => '1000',
    'NoAnonymous'        =>  'yes',
    'PAMAuthentication'  =>  'yes',
    'PureDB'             =>  '/etc/pure-ftpd/pureftpd.pdb',
    'TLSCipherSuite'     =>  'ALL:!aNULL:!SSLv3',
    'UnixAuthentication' =>  'no'
  }

  $default_ldap_config = deep_merge( {
    'LDAPConfigFile'  =>  $ldap_config_file
    }, $default_config)

  $default_mysql_config = deep_merge( {
    'MySQLConfigFile' =>  $mysql_config_file
    }, $default_config)

  $default_pgsql_config = deep_merge( {
    'PGSQLConfigFile' =>  $pgsql_config_file
    }, $default_config)

  $default_ssl = {
    'country'      => 'DE',
    'organization' => 'Pure-FTPd Puppet Snakeoil',
    'commonname'   =>  $::fqdn,
    'days'         => 3456
  }

  # defaults for the ldap.conf file
  $ldapconf_default = {
    'LDAPServer'     =>  'localhost',
    'LDAPPort'       =>  '389',
    'LDAPBaseDN'     =>  'cn=Users,dc=c9x,dc=org',
    'LDAPBindDN'     =>  'cn=Manager,dc=c9x,dc=org',
    'LDAPBindPW'     =>  'r00tPaSsw0rD',
    'LDAPAuthMethod' =>  'PASSWORD',
  }

  # defaults for the mysql.conf file
  $mysqlconf_default = {
    'MYSQLSocket'   =>  '/var/run/mysqld/mysqld.sock',
    'MYSQLUser'     =>  'root',
    'MYSQLPassword' =>  'rootpw',
    'MYSQLDatabase' =>  'pureftpd',
    'MYSQLCrypt'    =>  'cleartext',
    'MYSQLGetPW'    =>  'SELECT Password FROM users WHERE User=\'\L\'',
    'MYSQLGetUID'   =>  'SELECT Uid FROM users WHERE User=\'\L\'',
    'MYSQLGetGID'   =>  'SELECT Gid FROM users WHERE User=\'\L\'',
    'MYSQLGetDir'   =>  'SELECT Dir FROM users WHERE User=\'\L\'',
  }

  # defaults for the postgresql.conf file
  $pgsqlconf_default = {
    'PGSQLServer'   =>  'localhost',
    'PGSQLPort'     =>  '5432',
    'PGSQLUser'     =>  'postgres',
    'PGSQLPassword' =>  'rootpw',
    'PGSQLDatabase' =>  'pureftpd',
    'PGSQLCrypt'    =>  'cleartext',
    'PGSQLGetPW'    =>  'SELECT "Password" FROM "users" WHERE "User"=\'\L\'',
    'PGSQLGetUID'   =>  'SELECT "Uid" FROM "users" WHERE "User"=\'\L\'',
    'PGSQLGetGID'   =>  'SELECT "Gid" FROM "users" WHERE "User"=\'\L\'',
    'PGSQLGetDir'   =>  'SELECT "Dir" FROM "users" WHERE "User"=\'\L\'',
  }

}
