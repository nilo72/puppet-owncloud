# Simple OwnCloud module.
#
class owncloud {

  include apt

  package { 'apt-transport-https':
    ensure  => latest,
  }

  package {'open-vm-tools':
    ensure  => latest,
  }

  package { 'rsync':
    ensure  => latest,
  }

#  class{ 'site::staff_ssh':
#    allowed_groups => [ 'adm', 'root'],
#    password_auth => 'yes',
#  }

}

