# owncloud installation

class owncloud::install inherits owncloud {

  include apt

  package { 'php5-ldap':
    ensure  => latest,
  }

  package { 'php5-apcu':
    ensure  => latest,
  }

  package { 'php5-memcached':
    ensure  => latest,
  }

  package { 'libapache2-mod-xsendfile':
    ensure  => latest,
  }

  package { 'php5-imagick':
    ensure => latest,
  }

  case $::operatingsystem {
    'Debian': {
      if $owncloud::enterprise_community {
        apt::source { 'owncloud_enterprise':
          location   => $owncloud::apt_url_enterprise,
          release    => '/',
          repos      => '',
        }
      } else {
        apt::source { 'owncloud_community':
          location   => $owncloud::apt_url_community,
          release    => '/',
          repos      => '',
          key        => {
            id      => 'F9EA4996747310AE79474F44977C43A8BA684223',
            source  => 'https://download.owncloud.org/download/repositories/stable/Debian_8.0/Release.key',
          },
        }
      }
    }
    default: {
      fail ("operating system ${::operatingsystem} not supported by module owncloud")
    }
  }

  if $owncloud::enterprise_community {

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
    if $owncloud::do_Update {
      package { 'owncloud':
        ensure   => latest,
        require  => Apt::Source['owncloud_community'],
      }
    } else {
      package { 'owncloud':
        ensure   => present,
        require  => Apt::Source['owncloud_community'],
      }
    }
  }


  file { '/root/bin/':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
  }

  file { '/root/bin/prepdirs.bash':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0740',
    source  => 'puppet:///modules/owncloud/root/bin/prepdirs.bash',
    require => File['/root/bin'],
  }

  exec{ 'DOC-Root berechtigungen setzen':
    command => 'prepdirs.bash',
    path    => ['/usr/bin','/bin','/root/bin'],
    require => File['/root/bin/prepdirs.bash'],
    onlyif  => 'test `ls -l /var/www/owncloud/.htaccess | cut -d \' \' -f 1 -s` != \'-rw-r--r--\''
  }
}