# OwnCloud DB-Node
#

class owncloud::appnode(
  $enterprise_community=false,
  $apt_url_enterprise,
  $apt_url_community,
  $nfs_data_source,
  $fqd_name,
)
{
  
  #mounts {'Temp in RAM': source => 'none', dest => '/tmp', type => 'tmpfs,size=6G', opts => 'defaults' }

  cron{ 'OC-Cron':
    name => 'OC cronjob for background activities',
    command => 'php -f /var/www/htdocs/owncloud/cron.php',
	user  => 'www-data',
	minute => '*/15',
  }

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
    true:{
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
    false:{
      # update your package list
      package { 'owncloud':
        ensure  => latest,
        require  => [Apt::Source['owncloud_community'],Notify['Installing owncloud system']],
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

  package { 'php-apc':
    ensure  => latest,
  }

  package { 'libapache2-mod-xsendfile':
    ensure  => latest,
  }


  class{ 'apache':
    mpm_module => false,
	keepalive => 'On',
    keepalive_timeout => '2',
    max_keepalive_requests => '4096',
  }
  
  class { 'apache::mod::prefork':
      startservers    => "100",
      minspareservers => "100",
      maxspareservers => "2000",
      serverlimit     => "6000",
      maxclients      => "6000",
	  maxrequestsperchild => "4000",
  }

  file { '/var/www/owncloud/config/config.php':
    ensure  => present,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0640',
    content => template('owncloud/var/www/owncloud/config/config.php.erb'),
  }

  file { '/ocdata':
    ensure  => 'directory',
    owner   => 'www-data',
    group   => 'www-data',
    mode    => 750,
  }
  
  mounts {'OC Data-Files': 
 	source => $nfs_data_source,
	dest => '/ocdata',
	type => 'nfs',
	opts => 'rw,relatime,space_cache',
  }

  file { '/etc/sysctl.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/owncloud/etc/sysctl.conf',
  }
  
  file { '/etc/php5/conf.d/apc.ini':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/owncloud/etc/php5/conf.d/apc.ini',
  }
  
  apache::vhost { $fqd_name:
       port          => '80',
       docroot => '/var/www/owncloud',
       directories  => [ 
               { path           => '/var/www/owncloud', 
				 options => ['Indexes','SymLinksIfOwnerMatch'],
                 allow_override => ['All'],
				 custom_fragment => '
				     <IfModule mod_xsendfile.c>
					 	SetEnv MOD_X_SENDFILE_ENABLED 1
						XSendFile On
						XSendFilePath /tmp/oc-noclean
					 </IfModule>',
               }, 
             ],
	   docroot_owner => 'www-data',
	   docroot_group => 'www-data',
  }

#  class{ 'apache::mod::xsendfile':
#  options => {
#      'SetEnv'  => 'MOD_X_SENDFILE_ENABLED 1',
#      'XSendFile' => 'On',
#      'XSendFilePath'   => '/tmp/oc-noclean',
#    },
#  }
  include apache::mod::php
  include apache::mod::xsendfile
  	
  nagios::service{ 'apache_web_node':
    service_description => 'OwnCloud Apache App-Server',
    check_command => 'check_http',
    contact_groups => 'ail-admins',
  }
}
