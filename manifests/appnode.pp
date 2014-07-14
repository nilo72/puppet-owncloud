# OwnCloud DB-Node
#

class owncloud::appnode( 
  $apt_url,
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
      }
    }

  package { 'owncloud-enterprise':
    ensure  => latest,
    require  => [Apt::Source['owncloud_enterprise']],
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