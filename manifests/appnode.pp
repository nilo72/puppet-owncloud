# OwnCloud DB-Node
#

class owncloud::appnode(
  $enterprise_community=false,
  $apt_url_enterprise,
  $apt_url_community,
  $nfs_data_source,
  $fqd_name,
  $nfs_dump_db_source,
  $is_backup_host = false,
  $is_integration_host = false,)
{

  include apt

  cron{ 'OC-System-Cron':
    name    => 'OC cronjob for background activities',
    command => 'php -f /var/www/owncloud/cron.php',
    user    => 'www-data',
    minute  => '*/15',
  }

# TODO: validate parameters

  if $is_backup_host {

    cron { 'OC-Backup-cron':
      name    => 'OC-Backup cronjob',
      command => '/root/bin/ocappbackup.bash',
      user    => 'root',
      minute  => '10',
      hour    => '0',
      require => [Mounts['OC App-Dump-Files'],File['/root/bin/ocappbackup.bash']],
    }

    mounts { 'OC App-Dump-Files':
      source => $nfs_dump_db_source,
      dest   => '/ocappdump',
      type   => 'nfs',
      opts   => 'vers=3,suid',
    }

    file { '/root/bin/ocappbackup.bash':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0750',
      source  => 'puppet:///modules/site/ocgalera/root/bin/ocappbackup.bash',
      require => File['/root/bin/'],
    }
  }

  apt::key { 'owncloud':
    #id     => 'BA684223',
    id     => 'F9EA4996747310AE79474F44977C43A8BA684223',
    source => 'http://download.opensuse.org/repositories/isv:/ownCloud:/community/Debian_8.0/Release.key',
  }

  file { '/root/bin/':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
  }

  case $::operatingsystem {
    'debian': {
      if $enterprise_community {
          apt::source { 'owncloud_enterprise':
            location   => $apt_url_enterprise,
            release    => '/',
            repos      => '',
          }
        } else {
          apt::source { 'owncloud_community':
            location   => $apt_url_community,
            release    => '/',
            repos      => '',
          }
        }
      }
    default: {
      fail ("operating system ${::operatingsystem} not supported by module owncloud")
    }
  }

  if $enterprise_community {

    #Options if enterprise is selected
    package { 'owncloud-enterprise':
      ensure   => latest,
      require  => [Apt::Source['owncloud_enterprise']],
    }

    package { 'owncloud-enterprise-ldaphome':
      ensure   => latest,
      require  => [Apt::Source['owncloud_enterprise']],
    }

    package { 'cifs-utils':
      ensure  => latest,
    }

    #file{ 'credentials':
    #  ensure => present,
    #  chmod 600,
    #}

    } else {

    # update your package list
    package { 'owncloud':
      ensure   => present,
      require  => Apt::Source['owncloud_community'],
    }
  }

  package { 'rsync':
    ensure  => present,
  }

  file { '/etc/ldap/ldap.conf':
    source => 'puppet:///modules/site/ocgalera/etc/ldap/ldap.conf',
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  #file{ 'fstab' :
  #  ensure => present,
  #}

  package { 'php5-ldap':
    ensure  => latest,
  }

  package { 'php-apc':
    ensure  => latest,
  }

  package { 'libapache2-mod-xsendfile':
    ensure  => latest,
  }

  package { 'php5-imagick':
    ensure => latest,
  }

  package { 'libreoffice':
    ensure => latest,
  }

  class{ 'apache':
    mpm_module             => false,
    keepalive              => 'On',
    keepalive_timeout      => '2',
    max_keepalive_requests => '4096',
  }

  class { 'apache::mod::prefork':
    startservers        => '100',
    minspareservers     => '100',
    maxspareservers     => '2000',
    serverlimit         => '6000',
    maxclients          => '6000',
    maxrequestsperchild => '4000',
  }

  file { '/var/www/owncloud/config/config.php':
    ensure  => present,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0640',
    content => template('owncloud/var/www/owncloud/config/config.php.erb'),
  }

  file { '/root/bin/prepdirs.bash':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0740',
    source  => 'puppet:///modules/owncloud/root/bin/prepdirs.bash',
    require => File['/root/bin'],
  }

  file { '/ocdata':
    ensure  => directory,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0750',
  }

  if $is_integration_host {
    mounts {'OC Data-Files':
      source => $nfs_data_source,
      dest   => '/ocdata',
      type   => 'nfs',
      opts   => 'vers=3,suid',
    }
  }

  file { '/etc/sysctl.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/owncloud/etc/sysctl.conf',
  }

  file { '/etc/php5/conf.d':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/etc/php5/conf.d/apc.ini':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/owncloud/etc/php5/conf.d/apc.ini',
    require => File['/etc/php5/conf.d'],
  }

  apache::vhost { $fqd_name:
    port          => '80',
    docroot       => '/var/www/owncloud',
    directories   => [
      { path            => '/var/www/owncloud',
        options         => ['Indexes','SymLinksIfOwnerMatch'],
        allow_override  => ['All'],
        custom_fragment => '
          <IfModule mod_xsendfile.c>
            SetEnv MOD_X_SENDFILE_ENABLED 1
            XSendFile On
            XSendFilePath /tmp/oc-noclean
            XSendFilePath /ocdata
            </IfModule>',
      },
    ],
    docroot_owner => 'root',
    docroot_group => 'www-data',
  }

  apache::vhost { "${fqd_name}-SSL":
    ensure        => present,
    port          => '443',
    docroot       => '/var/www/owncloud',
    ssl           => true,
    directories   => [
      { path            => '/var/www/owncloud',
        options         => ['Indexes','SymLinksIfOwnerMatch'],
        allow_override  => ['All'],
        custom_fragment => '
        <IfModule mod_xsendfile.c>
          SetEnv MOD_X_SENDFILE_ENABLED 1
          XSendFile On
          XSendFilePath /tmp/oc-noclean
          XSendFilePath /ocdata
        </IfModule>',
      },
    ],
    docroot_owner => 'www-data',
    docroot_group => 'www-data',
  }

  include apache::mod::php
  include apache::mod::xsendfile

  nagios::service{ 'apache_web_node':
    service_description => 'OwnCloud Apache App-Server',
    check_command       => 'check_http',
    contact_groups      => 'ail-admins',
  }

  file { '/var/www/owncloud/core/img/logo.svg':
    ensure  => present,
    owner   => 'root',
    group   => 'www-data',
    mode    => '0640',
    source  => 'puppet:///modules/site/ocgalera/var/www/owncloud/core/img/logo.svg',
  }

  user { 'batman':
    ensure => present,
    shell  => '/bin/bash',
    system => true,
    home   => '/home/batman',
    groups => ['www-data','adm'],
  }

  exec{ 'DOC-Root berechtigungen setzen':
    command => 'prepdirs.bash',
    path    => ['/usr/bin','/bin','/root/bin'],
    require => File['/root/bin/prepdirs.bash'],
    onlyif  => "test `ls -l /var/www/owncloud/.htaccess | cut -d ' ' -f 1 -s` != '-rw-r--r--'"
  }

  file { '/home/batman/.shh':
    ensure  => directory,
    owner   => 'batman',
    group   => 'batman',
    mode    => '0644',
    require => File['/home/batman/'],
  }


  file { '/home/batman/':
    ensure  => directory,
    owner   => 'batman',
    group   => 'batman',
    mode    => '0644',
    require => User['batman'],
  }

  ssh_authorized_key { 'batman@ocvlog':
    user    => 'batman',
    type    => 'ssh-rsa',
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDQorL7vdCrom0bMA5marc4uAWMndhLKlzLTXYsHifiqJB6h1NLUesE5ovuY0iI9Zs4evD58dcQC5KRwe8SogFR7i9ufblMeYaDI4jtB19sZdHcTA2AJx0eOxvt7isge65Y68n3zv+3HrpkclExNj6mZjEG87sxk0vDsuaJBaV+LShlDUtmB/dhdA+LRUAqqHUhNVFB+J4StXHtk4fFXkOW0RwWEY6qwxuX/GDocN4Ss+nVcTmhBCC8lNjYLDjztxwuNiCSOyuEb+BRKb3/Kv/rcUEeBoO2xNFTG199zleVIiKd6F3foWS/pdH6B0v1/XVuiZMcCUZHceyUZTc9hJhd',
    require => File['/home/batman/.shh'],
  }
}
