require 'spec_helper'

describe 'owncloud' do

  let(:node) { 'testhost.example.org' }

  #let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }

  let(:facts) { {
      :concat_basedir             => '/tmp',
      :osfamily                   => 'Debian',
      :operatingsystem            => 'Debian',
      :lsbdistid                  => 'Debian',
      :operatingsystemrelease     => '8',
      :fqdn                       => 'testhost.example.org',
  }}

  let(:params) { {
      :site_name                  => 'owncloud.example.com',
  } }

  context 'with default settings' do
    it 'Compile' do
      should compile
    end

    it 'check defaults' do
      should contain_class('owncloud')
      should contain_class('owncloud::params')
    end

    it 'Steps for working' do
      should contain_anchor('owncloud::begin')
      should contain_anchor('owncloud::end')
    end

    it 'Used classes' do
      should contain_class('owncloud::install')
      should contain_class('owncloud::config')
      should contain_class('owncloud::service')
    end


    describe 'owncloud::install' do

      it 'use apt source' do
        should contain_apt__source('owncloud_community')
      end

      it 'installs packages' do
        should contain_package('owncloud')
        should contain_package('owncloud').with_ensure('present')
        should contain_package('php5-ldap')
        should contain_package('php5-apcu')
        should contain_package('php5-redis')
        should contain_package('php5-memcached')
        should contain_package('libapache2-mod-xsendfile')
        should contain_package('php5-imagick')
      end

      it 'contain files' do
        should contain_file('/root/bin/').with_ensure('directory')
        should contain_file('/root/bin/prepdirs.bash')
      end

      it 'execs commands' do
        should contain_exec('DOC-Root berechtigungen setzen')
        should contain_exec('DOC-Root berechtigungen setzen').with_command('prepdirs.bash')
      end

      it 'apache components' do
        should contain_apache__listen('443')
        should contain_apache__listen('80')
        should contain_apache__vhost('owncloud.example.com-SSL')
        should contain_apache__vhost('owncloud.example.com')
      end
    end

    describe 'owncloud::config' do
      it 'contain files' do
        should contain_file('/etc/php5/conf.d/apc.ini')
        should contain_file('/etc/php5/conf.d').with_ensure('directory')
        should contain_file('/etc/sysctl.conf')
        should contain_file('/etc/php5/apache2/php.ini')
        should contain_file('/var/www/owncloud/config/config.php')
        should contain_file('/var/www/owncloud/config/puppet.config.php')
      end

      it 'configures apache2 server' do
        should contain_class('apache')
        should contain_class('apache::mod::prefork')
        should contain_class('apache::mod::php')
        should contain_class('apache::mod::xsendfile')
        should contain_class('apache::mod::headers')
      end
    end

    describe 'owncloud::service' do

    end
  end


  context 'update the system' do
    let(:facts) { {
        :concat_basedir             => '/tmp',
        :osfamily                   => 'Debian',
        :operatingsystem            => 'Debian',
        :lsbdistid                  => 'Debian',
        :operatingsystemrelease     => '8'
    }}

    let(:params) { {
        :do_update                  => true,
        :trusted_domains            => ['hallo','welt'],
        :site_name                  => 'owncloud.example.com',
    }}

    describe 'owncloud::install' do
      it 'installs packages' do
        should contain_package('owncloud')
        should contain_package('owncloud').with_ensure('latest')
      end
    end
  end #context update system



  context 'use enterprise edition' do
    let(:facts) { {
        :concat_basedir             => '/tmp',
        :osfamily                   => 'Debian',
        :operatingsystem            => 'Debian',
        :lsbdistid                  => 'Debian',
        :operatingsystemrelease     => '8'
    }}

    let(:params) { {
        :enterprise_community       => true,
        :trusted_domains            => ['hallo','welt'],
        :site_name                  => 'owncloud.example.com',
    }}

    describe 'owncloud::install' do
      it 'use apt source' do
        should contain_apt__source('owncloud_enterprise')
      end

      it 'installs packages' do
        should contain_package('owncloud-enterprise')
        should contain_package('cifs-utils')
        should contain_package('owncloud-enterprise-ldaphome')
      end
    end
  end #context 'use enterprise edition'

  context 'check configuration settings' do
    let(:facts) { {
        :concat_basedir             => '/tmp',
        :osfamily                   => 'Debian',
        :operatingsystem            => 'Debian',
        :lsbdistid                  => 'Debian',
        :operatingsystemrelease     => '8'
    }}

    let(:params) { {
        :trusted_domains  => ['owncloud.example.com','192.168.10.3'],
        :dbpassword       => 'dirtyPassword',
        :site_name        => 'owncloud.example.com',
        :logfile          => '/var/log/192.168.10.1.owncloud.log',
        :redis            => ['host','localhost','port','4711'],
    }}

    describe 'owncloud::config' do
      it 'contain files' do
        should contain_file('/var/www/owncloud/config/puppet.config.php')
        should contain_file('/var/www/owncloud/config/puppet.config.php').with_content(/^*0 => 'owncloud.example.com',*/)
        should contain_file('/var/www/owncloud/config/puppet.config.php').with_content(/^*1 => '192.168.10.3',*/)
        should contain_file('/var/www/owncloud/config/puppet.config.php').with_content(/^*'trusted_domains' => array \( 0 => 'owncloud.example.com',1 => '192.168.10.3',\),*/)
        should contain_file('/var/www/owncloud/config/puppet.config.php').with_content(/^*'dbpassword' => 'dirtyPassword',*/)
        should contain_file('/var/www/owncloud/config/puppet.config.php').with_content(/^*'logfile' => '\/var\/log\/192.168.10.1.owncloud.log',*/)
        should contain_file('/var/www/owncloud/config/puppet.config.php').with_content(/^*'redis' => array ( 'host' => 'localhost', 'port' => 4711 )*/)
      end
    end
  end #context 'check configuration settings'

  context 'setup a clusternode' do
    let(:facts) { {
        :concat_basedir             => '/tmp',
        :osfamily                   => 'Debian',
        :operatingsystem            => 'Debian',
        :lsbdistid                  => 'Debian',
        :operatingsystemrelease     => '8'
    }}

    let(:params) { {
        :clusternode      => true,
        :site_name        => 'owncloud.example.com',
    }}

    describe 'owncloud::config' do
      it 'contain files' do
        should contain_file('/var/www/owncloud/config/autoconfig.php')
        is_expected.not_to contain_file('/var/www/owncloud/config/puppet.config.php')
      end
    end
  end #context 'use different trusted domains'
end #describe 'owncloud'
