require 'spec_helper'

describe 'owncloud' do
  let(:node) { 'testhost.example.org' }

  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }

  let(:facts) { {
    :osfamily        => 'Debian',
    :operatingsystem => 'Debian',
    :lsbdistid       => 'Debian',
  } }

  context 'with default settngs' do
    it 'Compile' do
      should compile
    end

    it 'Packages to be installed' do
      should contain_package('open-vm-tools')
      should contain_package('apt-transport-https')
    end
  end
end
