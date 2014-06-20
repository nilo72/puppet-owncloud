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
}