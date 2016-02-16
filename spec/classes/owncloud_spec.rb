require 'spec_helper'

describe 'owncloud' do
  let(:node) { 'testhost.example.org' }

  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }

  let(:facts) { {
    :concat_basedir             => '/tmp',
    :osfamily                   => 'Debian',
    :operatingsystem            => 'Debian',
    :lsbdistid                  => 'Debian',
    :operatingsystemrelease     => '8'
  }}

  context 'with default settings' do
    it 'Compile' do
      should compile
    end

    it 'Steps for working' do
      should contain_anchor('owncloud::begin')
      should contain_anchor('owncloud::end')
    end

    it 'Installed packages' do
      should contain_class('owncloud::install')
      should contain_class('owncloud::config')
      should contain_class('owncloud::service')
    end

   # describe 'owncloud::install' do
   #   it 'contain files' do
   #     should contain_file('/root/bin')
   #   end
   # end
  end
end
