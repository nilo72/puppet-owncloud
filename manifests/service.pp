class owncloud::service inherits owncloud{

  #owncloud service is driven via apace

  if !($owncloud::service_ensure in ['running','stopped']){
    fail('service_ensure parameter mus be running or stopped')
  }

#  if $owncloud::service_manage == true {
#    service { 'apache2':
#      ensure    => $owncloud::service_ensure,
#      enable    => $owncloud::service_enable,
#      name      => $owncloud::service_name,
#      hasstatus => true,
#      hasstart  => true,
#    }
#  }
}