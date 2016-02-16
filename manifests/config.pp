class owncloud::config inherits owncloud{

  file { '/var/www/owncloud/config/config.php':
    ensure  => present,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0640',
    content => template('owncloud/var/www/owncloud/config/config.php.erb'),
    #require => Package['owncloud'],
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
        </IfModule>

        Header always add Strict-Transport-Security "max-age=15768000"',
      },
    ],
    docroot_owner => 'www-data',
    docroot_group => 'www-data',
  }

  include apache::mod::php
  include apache::mod::xsendfile
  include apache::mod::headers

}