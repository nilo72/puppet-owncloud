# Simple OwnCloud module.
#
class owncloud {
	
  class{ 'apt':
   	always_apt_update => true;
  }
	
  notify {"Installing owncloud class":
   withpath => true,
  }
  
  package { 'apt-transport-https':
    ensure  => latest,
  }
  
  package { 'btrfs-tools':
    ensure => latest,
  }
  
  package {'open-vm-tools':
	ensure => latest,
  }
	
  package { 'rsync':
    ensure  => latest,
  }
	
  class { 'site':
    use_smarthost_mta => false,
    use_nfs => false,
    use_autofs    => false,
    use_staff_ssh => true,
    nagios_contactgroups  => ['Oliver Neumann', 'Michael Brodersen'],
    nagios_hostgroups     => ['Oliver Neumann', 'Michael Brodersen'],
  }
}

