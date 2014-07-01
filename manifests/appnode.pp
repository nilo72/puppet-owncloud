# OwnCloud DB-Node
#

class owncloud::appnode()
{
  include apt
  include apache
  
  nagios::service{ 'apache_web_node':
    service_description => 'OwnCloud Apache App-Server',
    check_command => 'check_http',
    contact_groups => 'ail-admins',
  }
  
  file { "/tmp/owncloud-6.0.3.tar.bz2":
    ensure => "/tmp/owncloud-6.0.3.tar.bz2",
    source => "puppet:///modules/owncloud/tmp/owncloud-6.0.3.tar.bz2",
  }
  
#  exec { "tar -xfvj /tmp/owncloud-6.0.3.tar.bz2":
#    ensure  => File["/tmp/owncloud-6.0.3.tar.bz2"],
#    cwd     => "/tmp",
#    creates => "/var/www/owncloud",
#    path    => ["/usr/bin", "/usr/sbin"]
#  }
}