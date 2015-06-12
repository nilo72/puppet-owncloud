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
      
    it { should contain_file('/etc/my.cnf').with_content(/ocdbfiles/) }
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
