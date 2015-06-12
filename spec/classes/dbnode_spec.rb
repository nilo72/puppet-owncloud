require 'spec_helper'

describe 'owncloud::dbnode', :type => :class do
  let(:node) { 'testhost.example.org' }
    
  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }

  let(:facts) { { 
    :osfamily        => 'Debian',
    :operatingsystem => 'Debian',
    :lsbdistid       => 'Debian',
  } }

  context 'with default settings' do

    let(:params)  { {
      :root_db_password      => 'test',
      :owncloud_db_password  => 'test',
      :db_monitor_host       => 'monitor.example.com',
      :node_ips              => '192.168.10.1,192.168.10.2',
      :nfs_dump_db_source    => 'test-nfs:/nfs-dump/path',
     } }
     
    it { should compile }
      
    it { should contain_package('galera') }
    it { should contain_package('btrfs-tools') }
      
#   it { should contain_class('mysql__server')}
#   it { should contain_class('mysql__server__monitor')}
#   it { should contain_resource('nagios__service')}
      
    it { should contain_mysql__db('ownclouddb').with(
      'password' => 'test',
      'user' => 'owncloud'
      ) }
      
    it { should contain_file('/etc/mysql/my.cnf') } # .with_content(/ocdbfiles/) }
      
      
#      Apt::Key[owncloud]
#      Apt::Source[mariadb]
#      Apt::Source[owncloud_community]
#      Class[Owncloud::Appnode]
#      Class[Owncloud::Dbnode]
#      Class[Owncloud]
#      Cron[OC-System-Cron]
#      Exec[DOC-Root berechtigungen setzen]
#      Exec[Disk Partition]
#      Exec[Format disk]
#      File[/etc/ldap/ldap.conf]
#      File[/etc/mysql/conf.d/cluster.cnf]
#      File[/etc/mysql/debian.cnf]
#      File[/etc/sysctl.conf]
#      File[/home/batman/.shh]
#      File[/home/batman/]
#      File[/ocdbfiles]
#      File[/root/bin/]
#      File[/root/bin/prepdirs.bash]
#      File[/tmp/sdb.in]
#      Group[mysql]
#      Mounts[OC DB-Files]
#      Mysql_user[frugnul@192.168.119.%]
#      Mysql_user[owncloud@192.168.119.%]
#      Package[apt-transport-https]
#      Package[open-vm-tools]
#      Package[owncloud]
#      Ssh_authorized_key[batman@ocvlog]
#      User[batman]
#      User[mysql]
  end

  context 'with extra db params' do
    let(:params)  { {
      :root_db_password      => 'test',
      :owncloud_db_password  => 'test',
      :db_monitor_host       => 'monitor.example.com',
      :owncloud_db_user      => 'frugnul',
      :owncloud_db_name      => 'frugnulDB',
      :node_ips              => '192.168.10.1,192.168.10.2',
      :nfs_dump_db_source    => 'test-nfs:/nfs-dump/path',
     }}
    it { should contain_mysql__db('frugnulDB').with(
        'password' => 'test',
        'user' => 'frugnul'
       ) }
  end
end
