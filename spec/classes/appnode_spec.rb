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
     
    it { should compile }

    it { should contain_user('batman') }
    it do
      should contain_apt__key('owncloud')
      should contain_apt__source('owncloud_community')
    end

    it do
      should contain_package('rsync')
      should contain_package('php-apc')
      should contain_package('php5-imagick')
      should contain_package('php5-ldap')
      should contain_package('libapache2-mod-xsendfile')
      should contain_package('libreoffice')
      should contain_package('owncloud')
    end

    it do
      should contain_file('/var/www/owncloud/config/config.php')
      should contain_file('/var/www/owncloud/core/img/logo.svg')
      should contain_file('/etc/php5/conf.d')
      should contain_file('/etc/php5/conf.d/apc.ini').with_require('File[/etc/php5/conf.d]')
      should contain_file('/etc/ldap/ldap.conf')
      should contain_file('/etc/sysctl.conf')
      should contain_file('/home/batman/')
      should contain_file('/home/batman/.shh')
      should contain_file('/ocdata')
      should contain_file('/root/bin/')
      should contain_file('/root/bin/prepdirs.bash')
    end

 #  it { should contain_apache__vhost('owncloud.informatik.haw-hamburg.de') }

    it { should contain_exec('DOC-Root berechtigungen setzen')}
    it { should contain_Cron('OC-System-Cron')}

    it { should contain_apache__vhost('https://owncloud.example.com-SSL').with_port('443') }
    it { should contain_apache__vhost('https://owncloud.example.com').with_port('80') }

  end

end
