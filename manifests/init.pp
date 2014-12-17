# Simple OwnCloud module.
#
class owncloud {
	
  package { 'apt-transport-https':
    ensure  => latest,
  }
  
  package { 'btrfs-tools':
	ensure => latest,
  }
	
	
  class { 'site':
    use_smarthost_mta => false,
    use_nfs => false,
    use_autofs    => false,
    use_staff_ssh => false,
    nagios_contactgroups  => ['Oliver Neumann', 'Michael Brodersen'],
    nagios_hostgroups     => ['Oliver Neumann', 'Michael Brodersen'],
  }
}

