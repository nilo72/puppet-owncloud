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
      
    it do
      should contain_package('galera').with({'ensure'  =>  'present',})
      should contain_package('btrfs-tools').with({'ensure'  =>  'latest',})
    end

    it do
      should contain_exec('Disk Partition')
      should contain_exec('Format disk')
    end

    it { should contain_mounts('OC DB-Files') }

    it do
      should contain_file('/ocdbfiles')
      should contain_file('/etc/mysql/conf.d/cluster.cnf')
      should contain_file('/etc/mysql/debian.cnf')
      should contain_file('/tmp/sdb.in')
    end

    it do
      should contain_user('mysql')
      should contain_group('mysql')
    end
#   it { should contain_class('mysql__server')}
#   it { should contain_class('mysql__server__monitor')}
#   it { should contain_resource('nagios__service')}
      
    it { should contain_mysql__db('ownclouddb').with(
      'password' => 'test',
      'user' => 'owncloud',
      ) }

    it { should contain_class('mysql::server') }

    it { should contain_mysql_user('owncloud@192.168.119.%') }

    it { should contain_mysql_database('ownclouddb') }

    #it { should contain_file('/etc/mysql/my.cnf') } # .with_content(/ocdbfiles/) }
      
    it do
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
    it do
      should contain_mysql__db('frugnulDB').with(
        'password' => 'test',
        'user' => 'frugnul'
       )
      should contain_mysql__db('frugnulDB').with_require('File[/etc/mysql/my.cnf]')
    end
    it { should contain_mysql_database('frugnulDB') }

    it { should contain_mysql_user('frugnul@192.168.119.%')}
  end
end
