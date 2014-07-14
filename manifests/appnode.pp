# OwnCloud DB-Node
#

class owncloud::appnode( 
  $apt_url,
  $node_ip=$::ipaddress,
  $node_name=$::fqdn,
  $node_ips,
  )
{
  include apt
  
  case $::operatingsystem {
    'debian': {
        apt::source { 'owncloud enterprise':
          location   => $apt_url,
          release    => 'wheezy',
          repos      => 'main',
      }
    }
  }
  
  package { 'owncloud-enterprise':
    ensure  => latest,
    require  => [Apt::Source['owncloud enterprise']],
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