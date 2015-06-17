# OwnCloud DB-Node
#

class owncloud::dbnode(
  $root_db_password,
  $owncloud_db_password,
  $db_monitor_host,
  $node_ips,
  $nfs_dump_db_source,
  $owncloud_db_name       = 'ownclouddb',
  $owncloud_db_user       = 'owncloud',
  $db_monitor_user        = 'nagios',
  $db_monitor_password    = 'nagios',
  $node_ip                = $::ipaddress,
  $node_name              = $::fqdn,
  $is_backup_host         = false,
)
{

  include apt

  exec { 'Disk Partition':
    command => 'sfdisk /dev/sdb < /tmp/sdb.in',
    path    => '/sbin',
    require => File['/tmp/sdb.in'],
    creates => '/dev/sdb1',
  }

  package { 'btrfs-tools':
    ensure  => latest,
  }

  exec { 'Format disk':
    command => 'mkfs.btrfs /dev/sdb1',
    path    => '/sbin/',
    #lint:ignore:quoted_strings-check would be hard to differentiate between ticks and backticks
    onlyif  => "/usr/bin/test  ! `blkid -o value -s TYPE /dev/sdb1` = btrfs",
    #lint:endignore
    require => [ Package['btrfs-tools'], Exec['Disk Partition']],
  }

  mounts { 'OC DB-Files':
    source  => '/dev/sdb1',
    dest    => '/ocdbfiles',
    type    => 'btrfs',
    opts    => 'rw,relatime,space_cache',
    require => Exec['Format disk'],
    before  => File['/ocdbfiles'],
  }

  file { '/ocdbfiles':
    ensure  => 'directory',
    owner   => 'mysql',
    group   => 'root',
    mode    => '0750',
    require => User['mysql'],
  }


  if $is_backup_host {
    cron{ 'OC-Backup-cron':
      name    => 'OC-DB-Backup cronjob',
      command => '/root/bin/ocdbbackup.bash',
      user    => 'root',
      minute  => '10',
      hour    => '0',
      require => [Mounts['OC DB-Dump-Files'],File['/root/bin/ocdbbackup.bash']],
    }

    mounts {'OC DB-Dump-Files':
      source => $nfs_dump_db_source,
      dest   => '/ocdbdump',
      type   => 'nfs',
      opts   => 'vers=3,suid',
    }

    file { '/ocdbdump':
      ensure  => 'directory',
      owner   => 'mysql',
      group   => 'root',
      mode    => '0750',
      require => User['mysql'],
    }

    file { '/root/bin/':
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => '0750',
    }

    file { '/root/bin/ocdbbackup.bash':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0750',
      source  => 'puppet:///modules/site/ocgalera/root/bin/ocdbbackup.bash',
      require => File['/root/bin/'],
    }
  }

  case $::operatingsystem {
    'ubuntu': {
      apt::source { 'mariadb':
        location   => 'http://mirror.netcologne.de/mariadb/repo/5.5/ubuntu',
        release    => 'saucy',
        repos      => 'main',
        key        => '1BB943DB',
        key_server => 'hkp://keyserver.ubuntu.com:80',
      }
    }
    'debian': {
      apt::source { 'mariadb':
        location   => 'http://mirror2.hs-esslingen.de/mariadb/repo/5.5/debian',
        release    => 'wheezy',
        repos      => 'main',
        key        => '1BB943DB',
        key_server => 'hkp://keyserver.ubuntu.com:80',
      }
    }
    default:  {
      fail ("operating system ${::operatingsystem} not supported by module owncloud")
    }
  }

  package { 'rsync':
    ensure  => present,
  }

  package { 'galera':
    ensure   => present,
    #require  => [Apt::Source['mariadb'],Package['rsync'],File['/etc/mysql/debian.cnf'],File['/etc/mysql/conf.d/cluster.cnf']],
    require  => [Apt::Source['mariadb'], Package['rsync']],
  }

  class { 'mysql::server':
    root_password    => $root_db_password,
    package_name     => 'mariadb-galera-server',
    #package_ensure   => '5.5.40-MariaDB-36.1'
    #service_enabled  => false,
    require          => [Package['galera'], Mounts['OC DB-Files']],
    #require          => [Package['galera'], Mounts['OC DB-Files']],
    override_options => {
      'mysqld' => {
        #'bind_address'            => $::ipaddress,
        'datadir'                 => '/ocdbfiles',
        'key_buffer_size'         => '512M',
        'innodb_buffer_pool_size' => '512M',
        'query_cache_type'        => '1',
        'query_cache_limit'       => '512M',
        'query_cache_size'        => '512M',
        'table_open_cache'        => '512',
        #'' => '',
      },},
  }

  notice("::mysql::server::config_file is ${::mysql::server::config_file}")

  class { 'mysql::server::monitor':
    mysql_monitor_username  => $db_monitor_user,
    mysql_monitor_password  => $db_monitor_password,
    mysql_monitor_hostname  => $db_monitor_host,
  }

  # Creates a database with a user and assign some privileges
  mysql::db { $owncloud_db_name:
    user     => $owncloud_db_user,
    password => $owncloud_db_password,
    # TODO: Who determined this IP addr?
    host     => '192.168.119.%',
    grant    => ['all'],
    require  => File[$::mysql::server::config_file],
  }

#  nagios::service{ 'galera_cluster_node':
#    service_description => 'OwnCloud galera cluster node DB',
#    check_command => 'check_mysql_cmdlinecred!nagios!nagios',
#    contact_groups => 'ail-admins',
#  }

  file { '/etc/mysql/conf.d/cluster.cnf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('owncloud/etc/mysql/conf.d/cluster.cnf.erb'),
  #before => Class['mysql::server'],
    #notify  => Service[$owncloud::dbnode]
  }

  file { '/etc/mysql/debian.cnf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/site/ocgalera/debian.cnf',
  #before => Class['mysql::server'],
  #notify  => Service['mysql'],
  }

  file{ '/tmp/sdb.in':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/site/ocgalera/sdb.in',
  }

  #NOTE: uid und gid des mysql user sind debianspezifisch

  user { 'mysql':
    ensure  => present,
    comment => 'MySQL Server',
    gid     => 'mysql',
    shell   => '/bin/false',
    home    => '/var/lib/mysql',
    require => Group['mysql'],
    system  => true,
  }

  group {'mysql':
    ensure => present,
    system => true,
  }
}
