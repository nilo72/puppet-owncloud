# Simple OwnCloud module.
#
class owncloud {
	

  notify {"Installing owncloud class":
   withpath => true,
  }
  
  package { 'apt-transport-https':
    ensure  => latest,
    notify {"Installing apt-transport-https":
     withpath => true,
    }
  }
  
  package { 'btrfs-tools':
    ensure => latest,
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

