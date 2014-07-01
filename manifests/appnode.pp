# OwnCloud DB-Node
#

class owncloud::appnode()
{
  include apt
  include apache
  include apache::mod::php
  
  nagios::service{ 'apache_web_node':
    service_description => 'OwnCloud Apache App-Server',
    check_command => 'check_http',
    contact_groups => 'ail-admins',
  }
  
  file { "/tmp/owncloud-6.0.3.tar.bz2":
    ensure => present,
    source => "puppet:///modules/owncloud/tmp/owncloud-6.0.3.tar.bz2",
  }

  exec { 
    "bunzip2 owncloud-6.0.3.tar.bz2":
    require  => File["/tmp/owncloud-6.0.3.tar.bz2"],
    cwd     => "/tmp",
    creates => "/var/www/owncloud",
    path    => ["/bin", "/usr/bin", "/usr/sbin"];

    "tar -xf /tmp/owncloud-6.0.3.tar -C /var/www":
    require  => Exec["bunzip2 owncloud-6.0.3.tar.bz2"],
    cwd     => "/tmp",
    creates => "/var/www/owncloud",
    path    => ["/bin", "/usr/bin", "/usr/sbin"];
  }
  
  file { "/var/www/owncloud":
           ensure => directory,
           recurse => true,
           owner => "www-data",
           group => "www-data",
           mode => 0644,
           require => Exec["tar -xf /tmp/owncloud-6.0.3.tar -C /var/www"]
   }
}