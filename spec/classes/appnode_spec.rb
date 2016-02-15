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
     
    it 'Compile' do
      should compile
    end

    it 'Users and Groups' do
      should contain_user('batman')
    end

    it 'Packages to be installed' do
      should contain_package('rsync')
      should contain_package('php5-apcu')
      should contain_package('php5-imagick')
      should contain_package('php5-ldap')
      should contain_package('php5-memcached')
      should contain_package('libapache2-mod-xsendfile')
      should contain_package('libreoffice')
      should contain_package('owncloud')
      #should contain_package('owncloud').with({:key => {
      #                                          :id     => 'F9EA4996747310AE79474F44977C43A8BA684223',
      #                                          :source  => 'https://download.owncloud.org/download/repositories/stable/Debian_8.0/Release.key',
      #},
      #}),
      should contain_package('owncloud').with_ensure('present')
    end

    it 'Classes to be included' do
      should contain_class('apache::mod::php')
      should contain_class('apache::mod::xsendfile')
      should contain_class('apache::mod::headers')
    end


    it 'Files to be copied' do
      should contain_file('/var/www/owncloud/config/config.php')
      should contain_file('/var/www/owncloud/core/img/logo.svg')
      should contain_file('/etc/php5/conf.d').with_ensure('directory')
      should contain_file('/etc/php5/conf.d/apc.ini').with_require('File[/etc/php5/conf.d]')
      should contain_file('/etc/ldap/ldap.conf')
      should contain_file('/etc/sysctl.conf')
      should contain_file('/home/batman/')
      should contain_file('/home/batman/.shh')
      should contain_file('/ocdata')
      should contain_file('/root/bin/')
      should contain_file('/root/bin/prepdirs.bash')
    end

    it 'Commands to be executed' do
      should contain_exec('DOC-Root berechtigungen setzen')
    end


    it 'Cronjobs to be initialized' do
      should contain_Cron('OC-System-Cron')
    end

    it 'Apache vhosts to be setup' do
      should contain_apache__vhost('https://owncloud.example.com-SSL').with_port('443')
      should contain_apache__vhost('https://owncloud.example.com').with_port('80')
    end

    it 'Nagios checks to be implemented' do
      should contain_nagios__service('apache_web_node')
    end

    it 'SSH-Key to be installed' do
      should contain_ssh_authorized_key('batman@ocvlog')
    end
  end


  context 'Doing an update' do

    let(:params)  { {
        :apt_url_enterprise   => 'http://example.com',
        :apt_url_community    => 'http://example.com',
        :nfs_data_source      => 'test-nfs:/some/path',
        :fqd_name             => 'https://owncloud.example.com',
        :nfs_dump_db_source   => 'test-nfs:/some/other/path',
        :do_Update            => true,
    } }

    it 'Packages to be installed' do
      should contain_package('owncloud').with_ensure('latest')
    end

  end
end
