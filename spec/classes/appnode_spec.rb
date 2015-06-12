require 'spec_helper'

describe 'owncloud::appnode', :type => :class do
  let(:node) { 'testhost.example.org' }
    
  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }

  let(:facts) { { 
    # the module concat needs this. Normaly set by concat through pluginsync
    :concat_basedir         => '/tmp/concatdir',
    # the apt and apache combined require the full lsb fact range
    :osfamily                 => 'Debian',
    :operatingsystem          => 'Debian',
    :operatingsystemrelease   => '8.1',
    :lsbdistcodename          => 'jessie',
    :lsbdistdescription       => 'Debian 8.1',
    :lsbdistrelease         => '8.1',
    :lsbdistid              => 'Debian', 
    :lsbmajdistrelease      => '8',
  } }

  context 'with default settings' do

    let(:params)  { {
      :apt_url_enterprise   => 'http://example.com',
      :apt_url_community    => 'http://example.com',
      :nfs_data_source      => 'test-nfs:/some/path',
      :fqd_name             => 'https://owncloud.example.com',
      :nfs_dump_db_source   => 'test-nfs:/some/other/path',
     } }
     
    it { should compile }
      
    it { should contain_package('rsync') }

    it { should contain_apache__vhost('https://owncloud.example.com-SSL').with_port('443') }
    it { should contain_apache__vhost('https://owncloud.example.com').with_port('80') }
      
#      Apt::Key[owncloud]
#      Apt::Source[owncloud_community]
#      Cron[OC-System-Cron]
#      Exec[DOC-Root berechtigungen setzen]
#      Exec[Disk Partition]
#      Exec[Format disk]
#      File[/etc/ldap/ldap.conf]
#      File[/etc/mysql/conf.d/cluster.cnf]
#      File[/etc/mysql/debian.cnf]
#      File[/etc/php5/conf.d/apc.ini]
#      File[/etc/php5/conf.d]
#      File[/etc/sysctl.conf]
#      File[/home/batman/.shh]
#      File[/home/batman/]
#      File[/ocdata]
#      File[/root/bin/]
#      File[/root/bin/prepdirs.bash]
#      File[/tmp/sdb.in]
#      File[/var/www/owncloud/config/config.php]
#      File[/var/www/owncloud/core/img/logo.svg]
#      Group[mysql]
#      Nagios::Service[apache_web_node]
#      Package[apt-transport-https]
#      Package[libapache2-mod-xsendfile]
#      Package[libreoffice]
#      Package[open-vm-tools]
#      Package[owncloud]
#      Package[php-apc]
#      Package[php5-imagick]
#      Package[php5-ldap]
#      Ssh_authorized_key[batman@ocvlog]
#      User[batman]
  end

end
