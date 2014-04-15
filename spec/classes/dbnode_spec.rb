require 'spec_helper'

describe 'owncloud::dbnode' do
  let(:node) { 'testhost.example.org' }
  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }

  context 'with default settngs' do
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
    should contain_resource('mysql__db').with({password => 'test', user => 'owncloud'})
end
  end
end
