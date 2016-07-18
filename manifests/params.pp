# OwnCloud Parameters

class owncloud::params {
  # parameters of owncloud config fils
  $instanceid                                 = undef # ''
  $passwordsalt                               = undef # ''
  $version                                    = undef # 'x.x.x.x'
  $installed                                  = undef # false
  $trusted_domains                            = undef # ['demo.example.org','otherdomain.example.org']
  $datadirectory                              = undef # '/var/www/owncloud/data'
  $dbtype                                     = undef # 'sqlite'
  $dbhost                                     = undef # ''
  $dbname                                     = undef # 'owncloud'
  $dbuser                                     = undef # ''
  $dbpassword                                 = undef # ''
  $dbtableprefix                              = undef # ''
  $default_language                           = undef # 'en'
  $defaultapp                                 = undef # 'files'
  $knowledgebaseenabled                       = undef # true
  $enable_avatars                             = undef # true
  $allow_user_to_change_display_name          = undef # true
  $remember_login_cookie_lifetime             = undef # 60*60*24*15
  $session_lifetime                           = undef # 60 * 60 * 24
  $session_keepalive                          = undef # true
  $skeletondirectory                          = undef # '/path/to/owncloud/core/skeleton'
  $user_backends                              = undef # 'array(array(\'class\' => \'OC_User_IMAP\',\'arguments\' =>
                                                      # array(\'{imap.gmail.com:993/imap/ssl}INBOX\')))'
  $lost_password_link                         = undef # 'https://example.org/link/to/password/reset'
  $mail_domain                                = undef # 'example.com'
  $mail_from_address                          = undef # 'owncloud'
  $mail_smtpdebug                             = undef # false
  $mail_smtpmode                              = undef # 'sendmail'
  $mail_smtphost                              = undef # '127.0.0.1'
  $mail_smtpport                              = undef # 25
  $mail_smtptimeout                           = undef # 10
  $mail_smtpsecure                            = undef # ''
  $mail_smtpauth                              = undef # false
  $mail_smtpauthtype                          = undef # 'LOGIN'
  $mail_smtpname                              = undef # ''
  $mail_smtppassword                          = undef # ''
  $overwritehost                              = undef # ''
  $overwriteprotocol                          = undef # ''
  $overwritewebroot                           = undef # ''
  $overwritecondaddr                          = undef # ''
  $overwrite_cli_url                          = undef # ''
  $proxy                                      = undef # ''
  $proxyuserpwd                               = undef # ''
  $trashbin_retention_obligation              = undef # 'auto'
  $versions_retention_obligation              = undef # 'auto'
  $appcodechecker                             = undef # true
  $updatechecker                              = undef # true
  $has_internet_connection                    = undef # true
  $check_for_working_webdav                   = undef # true
  $check_for_working_wellknown_setup          = undef # true
  $check_for_working_htaccess                 = undef # true
  $config_is_read_only                        = undef # false
  $log_type                                   = undef # 'owncloud'
  $logfile                                    = undef # '/var/log/owncloud.log'
  $oc_loglevel                                = undef # 2
  $syslog_tag                                 = undef # 'ownCloud'
  $log_condition                              = undef # 'array(\'shared_secret\' => \'57b58edb6637fe3059b3595cf9c41b9\',
                                                 #\'users\' => array(\'sample-user\'),\'apps\' => array(\'files\'),)'
  $logdateformat                              = undef # 'F d, Y H:i:s'
  $logtimezone                                = undef # 'Europe/Berlin'
  $log_query                                  = undef # false
  $cron_log                                   = undef # true
  $cron_lockfile_location                     = undef # ''
  $log_rotate_size                            = undef # false
  $thirdpartyroot                             = undef # ''
  $thirdpartyurl                              = undef # ''
  $customclient_desktop                       = undef # 'http://owncloud.org/sync-clients/'
  $customclient_android                       = undef # 'https://play.google.com/store/apps/details?id=com.owncloud.android'
  $customclient_ios                           = undef # 'https://itunes.apple.com/us/app/owncloud/id543672169?mt=8'
  $appstoreenabled                            = undef # true
  $appstoreurl                                = undef # 'https://api.owncloud.com/v1'
  $appstore_experimental_enabled              = undef # false
  $apps_paths                                 = undef # 'array(array(\'path\'=> \'/var/www/owncloud/apps\',\'url\' => \'/apps\'
                                                #,\'writable\' => true,),)'
  $enable_previews                            = undef # true
  $preview_max_x                              = undef # 2048
  $preview_max_y                              = undef # 2048
  $preview_max_scale_factor                   = undef # 10
  $preview_max_filesize_image                 = undef # 50
  $preview_libreoffice_path                   = undef # '/usr/bin/libreoffice'
  $preview_office_cl_parameters               = undef # ' --headless --nologo --nofirststartwizard --invisible --norestore
                                                #-convert-to pdf -outdir '
  $enabledPreviewProviders                    = undef # 'array(\'OC\Preview\PNG\',\'OC\Preview\JPEG\',\'OC\Preview\GIF\',
                                                #\'OC\Preview\BMP\',\'OC\Preview\XBitmap\',\'OC\Preview\MP3\',
                                                #\'OC\Preview\TXT\',\'OC\Preview\MarkDown\')'
  $ldapUserCleanupInterval                    = undef # 51
  $comments_managerFactory                    = undef # '\OC\Comments\ManagerFactory'
  $systemtags_managerFactory                  = undef # '\OC\SystemTag\ManagerFactory'
  $maintenance                                = undef # false
  $singleuser                                 = undef # false
  $openssl                                    = undef # 'array(\'config\' => \'/absolute/location/of/openssl.cnf\',)'
  $enable_certificate_management              = undef # false
  $memcache_local                             = undef # '\OC\Memcache\APCu'
  $memcache_distributed                       = undef # '\OC\Memcache\Memcached'
  $redis                                      = undef # 'array(\'host\' => \'localhost\' , \'port\' => 6379,\'timeout\' => 0.0,
                                                #\'password\' => \'\', \'dbindex\' => 0,)'
  $memcached_servers                          = undef # 'array(array(\'localhost\', 11211),)'
  $cache_path                                 = undef # ''
  $objectstore                                = undef # 'array(\'class\' => \'OC\\Files\\ObjectStore\\Swift\',\'arguments\' =>
                                                 #array(\'username\' => \'facebook100000123456789\',\'password\' =>
                                                 #\'Secr3tPaSSWoRdt7\',\'container\' => \'owncloud\',\'autocreate\'
                                                 #=> true,\'region\' => \'RegionOne\',\'url\' =>
                                                 #\'http://8.21.28.222:5000/v2.0\',\'tenantName\' =>
                                                 #\'facebook100000123456789\',\'serviceName\' => \'swift\',
                                                 #\'urlType\' => \'internal\'),)'
  $sharing_managerFactory                     = undef # '\OC\Share20\ProviderFactory'
  $dbdriveroptions                            = undef # ''
  $sqlite_journal_mode                        = undef # 'DELETE'
  $supportedDatabases                         = undef # 'array(\'sqlite\',\'mysql\',\'pgsql\',\'oci\',)'
  $tempdirectory                              = undef # '/tmp/owncloudtemp'
  $hashingCost                                = undef # 10
  $blacklisted_files                          = undef # 'array(\'.htaccess\')'
  $share_folder                               = undef # '/'
  $theme                                      = undef # ''
  $cipher                                     = undef # 'AES-256-CFB'
  $minimum_supported_desktop_version          = undef # '1.7.0'
  $quota_include_external_storage             = undef # false
  $filesystem_check_changes                   = undef # 0
  $asset_pipeline_enabled                     = undef # false
  $assetdirectory                             = undef # '/var/www/owncloud'
  $mount_file                                 = undef # '/var/www/owncloud/data/mount.json'
  $filesystem_cache_readonly                  = undef # false
  $secret                                     = undef # ''
  $trusted_proxies                            = undef # 'array(\'203.0.113.45\', \'198.51.100.128\')'
  $forwarded_for_headers                      = undef # 'array(\'HTTP_X_FORWARDED\', \'HTTP_FORWARDED_FOR\')'
  $max_filesize_animated_gifs_public_sharing  = undef # 10
  $filelocking_enabled                        = undef # true
  $memcache_locking                           = undef # '\\OC\\Memcache\\Redis'
  $debug                                      = undef # false
  $copied_sample_config                       = undef # true
  $adminlogin                                 = undef # 'admin'
  $adminpass                                  = undef # 'owncloud'

  # control parameters
  $clusternode                                = false
  $service_enable                             = true
  $service_ensure                             = 'running'
  $service_manage                             = true
  $service_name                               = 'apache2'
  $apt_url_community                          = 'http://download.owncloud.org/download/repositories/stable/Debian_8.0/'
  $apt_url_enterprise                         = 'enterprise'
  $do_Update                                  = false
  $enterprise_community                       = false

}
