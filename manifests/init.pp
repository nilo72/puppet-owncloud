# Simple OwnCloud module.
#
class owncloud {

  include site::staff_keys
	
  class{ 'apt':
   	always_apt_update => true;
  }
	
  package { 'apt-transport-https':
    ensure  => latest,
  }
  
  package { 'btrfs-tools':
    ensure  => latest,
  }
  
  package {'open-vm-tools':
    ensure  => latest,
  }

  package { 'rsync':
    ensure  => latest,
  }

#  class{ 'site::staff_ssh':
#  	allowed_groups => [ 'adm', 'root'],
#    password_auth => 'yes',
#  }

  class { 'site':
    use_smarthost_mta     => false,
    use_nfs               => false,
    use_autofs            => false,
    use_staff_ssh         => false,
    use_ldap_auth         => false,
    nagios_contactgroups  => ['Oliver Neumann', 'Michael Brodersen'],
    nagios_hostgroups     => ['Oliver Neumann', 'Michael Brodersen'],
  }
}

