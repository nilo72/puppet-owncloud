require 'spec_helper'

describe 'owncloud::appnode', :type => :class do
  let(:node) { 'testhost.example.org' }
    
  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }

  let(:facts) { { 
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
  end

end
