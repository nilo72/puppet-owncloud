# OwnCloud DB-Node
#

class owncloud::appnode(
  $enterprise_cummunity='false',
  $apt_url_enterpise,
  $apt_url_cummunity,
)
{
  include apt

  case $::operatingsystem {
    'debian': {
      apt::source { 'owncloud_enterprise':
        location   => $apt_url,
        release    => '/',
        repos      => '',
      }
      apt::source { 'owncloud_community':
        location   => $apt_url,
        release    => '/',
        repos      => '',
      }
      }
    }

  case $enterprise_community {
    #Options if enterprise is selected
    'true':{
        package { 'owncloud-enterprise':
          ensure  => latest,
          require  => [Apt::Source['owncloud_enterprise']],
        }

        package { 'owncloud-enterprise-ldaphome':
          ensure  => latest,
          require  => [Apt::Source['owncloud_enterprise']],
        }

        package { 'cifs-utils':
          ensure  => latest,
        }
  
        file{ 'credentials':
          ensure => present,
          chmod 600
        }
    }
    'false':{
      package { 'owncloud':
        ensure  => latest,
        require  => [Apt::Source['owncloud_community']],
      }
    }
  }
  
  file{ 'fstab' :
    ensure => present,
  }
  
  package { 'php5-ldap':
    ensure  => latest,
  }

  class{ 'apache':
    mpm_module => prefork,
  }

  include apache::mod::php

  nagios::service{ 'apache_web_node':
    service_description => 'OwnCloud Apache App-Server',
    check_command => 'check_http',
    contact_groups => 'ail-admins',
  }
}