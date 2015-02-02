# OwnCloud DB-Node
#

class owncloud::appnode(
  $enterprise_community='false',
  $apt_url_enterprise,
  $apt_url_community,
)
{
  include apt

  #mounts {'Temp in RAM': source => 'none', dest => '/tmp', type => 'tmpfs,size=6G', opts => 'defaults' }


  apt::key { 'owncloud':
    key        => 'BA684223',
    key_source => 'http://download.opensuse.org/repositories/isv:ownCloud:community/Debian_7.0/Release.key',
  }

  case $::operatingsystem {
    'debian': {
      apt::source { 'owncloud_enterprise':
        location   => $apt_url_enterprise,
        release    => '/',
        repos      => '',
      }
      apt::source { 'owncloud_community':
        location   => $apt_url_community,
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
  
        #file{ 'credentials':
        #  ensure => present,
        #  chmod 600,
        #}
    }
    'false':{
      # update your package list
      exec { 'apt-get update':
              command => '/usr/bin/apt-get update',
      }
      
      package { 'owncloud':
        ensure  => latest,
        require  => [Apt::Source['owncloud_community'],Exec['apt-get update'],Notify['Installing owncloud system']],
      }
	  
	  notify {"Installing owncloud system":
	   withpath => true,
	  }
	  
    }
  }
  
  #file{ 'fstab' :
  #  ensure => present,
  #}
  
  package { 'php5-ldap':
    ensure  => latest,
  }

  package { 'php5-apc':
    ensure  => latest,
  }

  package { 'libapache2-mod-xsendfile':
    ensure  => latest,
  }


  class{ 'apache':
    mpm_module => false,
  }
  
  class { 'apache::mod::prefork':
      startservers    => "100",
      minspareservers => "100",
      maxspareservers => "2000",
      serverlimit     => "6000",
      maxclients      => "6000",
	  maxrequestsperchild => "4000",
  }
  
  apache::vhost { 'owncloud.informatik.haw-hamburg.de':
       port          => '80',
       docroot => '/var/www/owncloud',
	   keepalive => 'On',
	   keepalive_timeout => '',
	   max_keepalive_requests => '4096',
       directories  => [ 
               { path           => '/var/www/owncloud', 
				 options => ['Indexes','SymLinksIfOwnerMatch'],
                 allow_override => ['All'],
               }, 
             ],
	   docroot_owner => 'www-data',
	   docroot_group => 'www-data',
  }

  include apache::mod::php

  nagios::service{ 'apache_web_node':
    service_description => 'OwnCloud Apache App-Server',
    check_command => 'check_http',
    contact_groups => 'ail-admins',
  }
}