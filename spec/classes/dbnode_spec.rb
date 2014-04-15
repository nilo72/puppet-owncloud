require 'spec_helper'

describe 'owncloud::dbnode' do
  let(:node) { 'testhost.example.org' }
  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }
  let(:facts) { { :osfamily => 'Debian',
                   :operatingsystem => 'Debian',
                   :lsbdistid => 'Debian',
			  } }
  
  context 'with default settings' do
    let(:params)  { {
      :root_db_password    => 'test',
      :owncloud_db_password  => 'test',
      :db_monitor_host => 'monitor.example.com',
     }}
    it do
      
    should compile
    should contain_package('galera')
    #should contain_class('mysql__server')
    #should contain_class('mysql__server__monitor')
    #should contain_resource('nagios__service')
    should contain_mysql__db('ownclouddb').with(
    	'password' => 'test',
    	'user' => 'owncloud',
    )
	end
  end
    context 'with extra db params' do
    let(:params)  { {
      :root_db_password    => 'test',
      :owncloud_db_password  => 'test',
      :db_monitor_host => 'monitor.example.com',
      :owncloud_db_user => 'frugnul',
      :owncloud_db_name => 'frugnulDB'
     }}
    it should contain_mysql__db('frugnulDB').with(
    	'password' => 'test',
    	'user' => 'frugnul',
    )
  end
end
