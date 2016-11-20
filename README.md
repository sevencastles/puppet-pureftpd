# puppet-pureftpd

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
2. [Setup - The basics of getting started with pureftpd](#setup)
    * [Beginning with pureftpd](#beginning-with-pureftpd)
3. [Usage - Configuration options and additional functionality](#usage)
    * [Hiera](#hiera)
    * [Customize options](#customize-options)
    * [Known Options (Debian)](#known-options-debian)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Module Description

The pureftpd module installs, configures, and manages the Pure-FTPd service.

This module manages both the installation and configuration of Pure-FTPd. It manages also different Pure-FTPd versions with compiled backends like MySQL, PostgreSQL and LDAP.

## Setup

### Beginning with pureftpd

To install a server with the default options:

`include '::pureftpd'`.

To install a server with MySQL, PostgreSQL or LDAP backend you need to set the "server_type":

```puppet
class { '::pureftpd':
  server_type  => 'mysql',
  mysql_config => { }
}
```

See [**Config Options**](#config-options) below for examples of the hash structure for `$config`, `$ldap_config`, `$mysql_config` and `$pgsql_config`.

## Usage

All interaction is done via `pureftpd`. There is no additional public class available.

### Hiera

This module is fully configureable with hiera. Only include the module with

```puppet
include '::pureftpd'
```
and setup your configuration in hiera here with yaml backend:

```yaml
---
pureftpd::config:
  'TLS': 1
pureftpd::manage_ssl: true
pureftpd::server_mode: standalone
pureftpd::server_type: mysql
pureftpd::ssl_config:
  'country': 'US'
  'organization': 'example.org Inc.'
  'commonname': 'ftp.example.org'
pureftpd::virtualchroot: true
```

### Config Options

To define server options, structure a hash structure of config `key` => `value` pairs. This hash create for each `key` a file with content of `value`:

```puppet
$config = {
  'AltLog'      => 'clf:/var/log/pure-ftpd/transfer.log',
  'FSCharset'   => 'UTF-8',
  'MinUID'      => '1000',
  'NoAnonymous' => 'yes'
}
```

This will create for example the following files:

```
root@localhost:~# tail /etc/pure-ftpd/conf/*
==> /etc/pure-ftpd/conf/AltLog <==
clf:/var/log/pure-ftpd/transfer.log

==> /etc/pure-ftpd/conf/FSCharset <==
UTF-8

==> /etc/pure-ftpd/conf/MinUID <==
1000

==> /etc/pure-ftpd/conf/NoAnonymous <==
yes

```

### Known Options (Debian)

This following options will be parsed by the pure-ftpd-wrapper. This List is maybe not completely and just for reference.

```perl
'AnonymousCantUpload' => ['-i'],
'AnonymousOnly', => ['-e'],
'AnonymousRatio' => ['-q %d:%d', \&parse_number_2],
'AntiWarez' => ['-s'],
'AutoRename' => ['-r'],
'Bind' => ['-S %s', \&parse_string],
'BrokenClientsCompatibility' => ['-b'],
'CallUploadScript' => ['-o'],
'ChrootEveryone' => ['-A'],
'CreateHomeDir' => ['-j'],
'CustomerProof' => ['-Z'],
'Daemonize' => ['-B'],
'DisplayDotFiles' => ['-D'],
'DontResolve' => ['-H'],
'ForcePassiveIP' => ['-P %s', \&parse_string],
'FortunesFile' => ['-F %s', \&parse_filename],
'FSCharset' => ['-8 %s', \&parse_string],
'ClientCharset' => ['-9 %s', \&parse_string],
'IPV4Only' => ['-4'],
'IPV6Only' => ['-6'],
'KeepAllFiles' => ['-K'],
'LimitRecursion' => ['-L %d:%d', \&parse_number_2_unlimited],
'LogPID' => ['-1'],
'MaxClientsNumber' => ['-c %d', \&parse_number_1],
'MaxClientsPerIP' => ['-C %d', \&parse_number_1],
'MaxDiskUsage' => ['-k %d', \&parse_number_1],
'MaxIdleTime' => ['-I %d', \&parse_number_1],
'MaxLoad' => ['-m %d', \&parse_number_1],
'MinUID' => ['-u %d', \&parse_number_1],
'NATmode' => ['-N'],
'NoAnonymous' => ['-E'],
'NoChmod' => ['-R'],
'NoRename' => ['-G'],
'NoTruncate' => ['-0'],
'PassivePortRange' => ['-p %d:%d', \&parse_number_2],
'PerUserLimits' => ['-y %d:%d', \&parse_number_2],
'ProhibitDotFilesRead' => ['-X'],
'ProhibitDotFilesWrite' => ['-x'],
'Quota' => ['-n %d:%d', \&parse_number_2],
'SyslogFacility' => ['-f %s', \&parse_word, 99],
'TLS' => ['-Y %d', \&parse_number_1],
'TLSCipherSuite' => ['-J %s', \&parse_string],
'TrustedGID' => ['-a %d', \&parse_number_1],
'TrustedIP' => ['-V %s', \&parse_ip],
'Umask' => ['-U %s:%s', \&parse_umask],
'UserBandwidth' => ['-T %s', \&parse_number_1_2],
'UserRatio' => ['-Q %d:%d', \&parse_number_2],
'VerboseLog' => ['-d'],
```

## Reference

### Classes

#### Public classes

* [`pureftpd`](#pureftpd): Installs and configures the complete Pure-FTPd.

#### Private classes

* `pureftpd::install`: Installs and manage packages.
* `pureftpd::config`: Configures the Pure-FTPd server.
* `pureftpd::service`: Manages the service.

### Parameters

#### pureftpd

##### `config`

Specifies options which parsed by pure-ftpd-wrapper. This must be a hash.

```puppet
$config = {
  'AltLog'      => 'clf:/var/log/pure-ftpd/transfer.log',
  'FSCharset'   => 'UTF-8',
  'MinUID'      => '1000',
  'NoAnonymous' => 'yes'
}
```

See [**Customize Options**](#customize-options) and [**Known Options (Debian)**](#known-options-debian) above for usage details.


#####  `config_db_dir`

Absolute path to directory for backend configuration files. Value must be a string.

Default: `/etc/pure-ftpd/db`


#####  `config_dir`

Absolute path to directory for configuration files. Value must be a string.

Default: `/etc/pure-ftpd/conf`

##### `config_manage`

Whether the Pure-FTPd configuration files should be managed. Valid values are true, false. Defaults to true.

##### `dir_aliases`

Specifies options to pass pureftpd-dir-aliases file. Structured like a hash, same as `config`:

```puppet
$dir_aliases = {
  'public'  => '/srv/public',
  'uploads' => '/tmp/uploads'
}
```

##### `dir_aliases_file`

Absolute path to directory for configuration files. Value must be a string.

Default: `/etc/pure-ftpd/pureftpd-dir-aliases`

##### `install_options`

Passes [install_options](https://docs.puppetlabs.com/references/latest/type.html#package-attribute-install_options) array to managed package resources. You must pass the appropriate options for the specified package manager. Defaults to undefined.

##### `ldap_config`

Configures the `ldap.conf` options in the `config_db_dir`. Structured like a hash, same as `config`:

```puppet
$ldap_config = {
  'public'  => '/srv/public',
  'uploads' => '/tmp/uploads'
}
```
###### Available Options List

- LDAPServer
- LDAPPort
- LDAPBaseDN
- LDAPBindDN
- LDAPBindPW
- LDAPDefaultUID
- LDAPDefaultGID
- LDAPFilter
- LDAPHomeDir
- LDAPVersion
- LDAPUseTLS
- LDAPAuthMethod
- LDAPDefaultHomeDirectory

For more information see the file itself. All comments available.

##### `ldap_config_file`

Absolute path to file for ldap configuration. Value must be a string.

Default: `/etc/pure-ftpd/db/ldap.conf`

##### `manage_ssl`

This options needs the [openssl module from camptocamp](https://forge.puppet.com/camptocamp/openssl) it provides an self-signed certificate, which is needed if you will use SSL/TLS. For more configuration see [`ssl_config`](#ssl-config) and [`ssl_pemfile`](#ssl-pemfile). Defaults to false.

##### `mysql_config`

Configures the `mysql.conf` options in the `config_db_dir`. Structured like a hash, same as `config`:

```puppet
$mysql_config = {
  'public'  => '/srv/public',
  'uploads' => '/tmp/uploads'
}
```
###### Available Options List

- MYSQLServer
- MYSQLPort
- MYSQLSocket
- MYSQLUser
- MYSQLPassword
- MYSQLDatabase
- MYSQLCrypt
- MYSQLGetPW
- MYSQLGetUID
- MYSQLDefaultUID
- MYSQLGetGID
- MYSQLDefaultGID
- MYSQLGetDir
- MySQLGetQTAFS
- MySQLGetQTASZ
- MySQLGetRatioUL
- MySQLGetRatioDL
- MySQLGetBandwidthUL
- MySQLGetBandwidthDL
- MySQLForceTildeExpansion
- MySQLTransactions

For more information see the file itself. All comments available.

##### `mysql_config_file`

Absolute path to file for ldap configuration. Value must be a string.

Default: `/etc/pure-ftpd/db/mysql.conf`

##### `package_ensure`

Whether the package exists or should be a specific version. Valid values are 'present', 'absent', or 'x.y.z'. Defaults to 'present'.

##### `package_manage`

Whether to manage the Pure-FTPd server package. Defaults to true.

##### `package_name`

The name of the Pure-FTPd server package to install. Defaults are OS dependent, defined in params.pp. Used if `server_type` is set to 'default'.

##### `package_name_ldap`

The name of the Pure-FTPd server package to install. Defaults are OS dependent, defined in params.pp. Used if `server_type` is set to 'ldap'.

##### `package_name_mysql`

The name of the Pure-FTPd server package to install. Defaults are OS dependent, defined in params.pp. Used if `server_type` is set to 'mysql'.

##### `package_name_pgsql`

The name of the Pure-FTPd server package to install. Defaults are OS dependent, defined in params.pp. Used if `server_type` is set to 'postgres'.

##### `pgsql_config`

Configures the `postgresql.conf` options in the `config_db_dir`. Structured like a hash, same as `config`:

```puppet
$mysql_config = {
  'public'  => '/srv/public',
  'uploads' => '/tmp/uploads'
}
```
###### Available Options List

- PGSQLServer
- PGSQLPort
- PGSQLUser
- PGSQLPassword
- PGSQLDatabase
- PGSQLCrypt
- PGSQLGetPW
- PGSQLGetUID
- PGSQLDefaultUID
- PGSQLGetGID
- PGSQLDefaultGID
- PGSQLGetDir
- PGSQLGetQTAFS
- PGSQLGetQTASZ
- PGSQLGetRatioUL
- PGSQLGetRatioDL
- PGSQLGetBandwidthUL
- PGSQLGetBandwidthDL

For more information see the file itself. All comments available.

##### `pgsql_config_file`

Absolute path to file for postgresql configuration. Value must be a string.

Default: `/etc/pure-ftpd/db/postgresql.conf`

##### `purge_conf_dir`

Whether the `config_db_dir` and `config_dir` directory should be purged. Valid values are true, false. Defaults to true.

##### `restart`

Whether the service should be restarted when things change. Valid values are true, false. Defaults to true.

##### `server_mode`

Whether the service should start in 'standalone' or 'inetd' mode. Defaults to standalone.

##### `server_type`

Defines which server type for Pure-FTPd should be used. Valid options are 'default', 'postgres', 'ldap', 'mysql'.
Defaults to default.

**Note** After a server type is installed an managed and if you would like to switch to another type. Remove / Purge first and then switch server_type.

##### `service_enabled`

Specifies whether the service should be enabled. Valid values are true, false. Defaults to true.

##### `service_manage`

Specifies whether the service should be managed. Valid values are true, false. Defaults to true.

##### `service_name`

The name of the Pure-FTPd server service. Defaults are OS dependent, defined in params.pp.  Used if `server_type` is set to 'default'.

##### `service_name_ldap`

The name of the Pure-FTPd server service. Defaults are OS dependent, defined in params.pp.  Used if `server_type` is set to 'ldap'.

##### `service_name_mysql`

The name of the Pure-FTPd server service. Defaults are OS dependent, defined in params.pp.  Used if `server_type` is set to 'mysql'.

##### `service_name_pgsql`

The name of the Pure-FTPd server service. Defaults are OS dependent, defined in params.pp.  Used if `server_type` is set to 'postgres'.

##### `service_provider`

The provider to use to manage the service. Defaults to 'systemd'.

##### `ssl_config`

Optional hash of values to create the self-signed certificate with openssl. This is only used if [`manage_ssl`](#manage_ssl) is set to true.

```puppet
$ssl_config => {
  'public'  => '/srv/public',
  'uploads' => '/tmp/uploads'
}
```
###### Available Options List

- country (2 digit country code)
- organization (String)
- commonname (fqdn)
- days

##### `ssl_pemfile`

Absolute path to file where the self-signed certificate and private key will be placed. Value must be a string. Used only if `manage_ssl` is enabled.

Default: `/etc/ssl/private/pure-ftpd.pem`

##### `uploadgid`

If set, pure-uploadscript will spawn running as the given gid. Defaults to undefined.

##### `uploaduid`

If set, pure-uploadscript will spawn running as the given uid. Defaults to undefined.

##### `uploadscript`

If this is set and the daemon is run in standalone mode, pure-uploadscript will also be run to spawn the program given below for handling uploads. Defaults to undefined.

##### `virtualchroot`

Whether to use binary with virtualchroot support valid values are "true" or "false". Defaults to false.

### Defines

Defines not used in this module.

### Types

This module currently uses no puppet Types.

### Facts

Currently the module does not provide any facts. If some facts are required open an issue.

## Limitations

This module has been tested on:

* Debian 8

My main distribution is Debian and to support other platforms please let me note the differences,
that we can append this platform.

Testing on other platforms has been minimal and cannot be guaranteed.

## Development

This puppet module is published under Apache-2.0 license and full opensource. Do
not hesitate to contact the main developer on GitHub and open bugs, merge requests
or anything else.

### Authors

This module is initial written by Benjamin Kübler. The following contributors have contributed to this module:

* Benjamin Kübler
