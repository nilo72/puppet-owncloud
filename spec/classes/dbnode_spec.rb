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
     
    it 'Compile' do
      should compile
    end
      
    it 'Packages to be installed' do
      should contain_package('galera').with_ensure('present')
      should contain_package('btrfs-tools').with({'ensure'  =>  'latest',})
    end

    it 'Commands to be executed' do
      should contain_exec('Disk Partition')
      should contain_exec('Format disk')
    end

    it 'Mount filesystems' do
       should contain_mounts('OC DB-Files')
    end

    it 'Files to be copied' do
      should contain_file('/ocdbfiles')
      should contain_file('/etc/mysql/conf.d/cluster.cnf')
      should contain_file('/etc/mysql/debian.cnf')
      should contain_file('/tmp/sdb.in')
    end

    it 'Users and Groups' do
      should contain_user('mysql')
      should contain_group('mysql')
    end

    it 'Nagios services' do
      should contain_nagios__service('galera_cluster_node')
    end
      
    it 'Database config' do
      should contain_mysql__db('ownclouddb').with('password' => 'test','user' => 'owncloud','host' => '192.168.119.%',)
      should contain_mysql__db('ownclouddb').with('password' => 'test','user' => 'owncloud',).with_require('File[/etc/mysql/my.cnf]')
      should contain_class('mysql::server')
      should contain_class('mysql::server::monitor')
      should contain_mysql_user('owncloud@192.168.119.%')
      should contain_mysql_database('ownclouddb')
    end


#    it { should contain_file('/etc/mysql/my.cnf') } # .with_content(/ocdbfiles/) }
      
    it 'APT-Sources and keys' do
      should contain_class('apt')
      should contain_apt__source('mariadb')
    end
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
    it 'Database config' do
      should contain_mysql__db('frugnulDB').with(
        'password' => 'test',
        'user' => 'frugnul'
       )
      should contain_mysql__db('frugnulDB').with_require('File[/etc/mysql/my.cnf]')
      should contain_mysql__db('frugnulDB').with_user('frugnul')
      should contain_mysql_database('frugnulDB')
      should contain_mysql_user('frugnul@192.168.119.%')
  end
  end
  end
