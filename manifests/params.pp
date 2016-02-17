# OwnCloue Parameters

class owncloud::params {
  # parameters of owncloud config fils
  $instanceid                                 = undef
  $passwordsalt                               = undef
  $trusted_domains                            = 'array (\'demo.example.org\',\'otherdomain.example.org\')'
  $datadirectory                              = '/var/www/owncloud/data'
  $version                                    = undef
  $dbtype                                     = 'sqlite'
  $dbhost                                     = ''
  $dbname                                     = 'owncloud'
  $dbuser                                     = ''
  $dbpassword                                 = ''
  $dbtableprefix                              = ''
  $installed                                  = undef
  $default_language                           = 'en'
  $defaultapp                                 = 'files'
  $knowledgebaseenabled                       = true
  $enable_avatars                             = true
  $allow_user_to_change_display_name          = true
  $remember_login_cookie_lifetime             = 60*60*24*15
  $session_lifetime                           = 60 * 60 * 24
  $session_keepalive                          = true
  $skeletondirectory                          = '/path/to/owncloud/core/skeleton'
  $user_backends                              = 'array(array(\'class\' => \'OC_User_IMAP\',\'arguments\' => array(\'{imap.gmail.com:993/imap/ssl}INBOX\')))'
  $lost_password_link                         = 'https://example.org/link/to/password/reset'
  $mail_domain                                = 'example.com'
  $mail_from_address                          = 'owncloud'
  $mail_smtpdebug                             = false
  $mail_smtpmode                              = 'sendmail'
  $mail_smtphost                              = '127.0.0.1'
  $mail_smtpport                              = 25
  $mail_smtptimeout                           = 10
  $mail_smtpsecure                            = ''
  $mail_smtpauth                              = false
  $mail_smtpauthtype                          = 'LOGIN'
  $mail_smtpname                              = ''
  $mail_smtppassword                          = ''
  $overwritehost                              = ''
  $overwriteprotocol                          = ''
  $overwritewebroot                           = ''
  $overwritecondaddr                          = ''
  $overwrite_cli_url                          = ''
  $proxy                                      = ''
  $proxyuserpwd                               = ''
  $trashbin_retention_obligation              = 'auto'
  $versions_retention_obligation              = 'auto'
  $appcodechecker                             = true
  $updatechecker                              = true
  $has_internet_connection                    = true
  $check_for_working_webdav                   = true
  $check_for_working_wellknown_setup          = true
  $check_for_working_htaccess                 = true
  $config_is_read_only                        = false
  $log_type                                   = 'owncloud'
  $logfile                                    = '/var/log/owncloud.log'
  $oc_loglevel                                = 2
  $syslog_tag                                 = 'ownCloud'
  $log_condition                              = '[\'shared_secret\' => \'57b58edb6637fe3059b3595cf9c41b9\',\'users\' => [\'sample-user\'],\'apps\' => [\'files\'],],'
  $logdateformat                              = 'F d, Y H:i:s'
  $logtimezone                                = 'Europe/Berlin'
  $log_query                                  = false
  $cron_log                                   = true
  $cron_lockfile_location                     = ''
  $log_rotate_size                            = false
  $thirdpartyroot                             = ''
  $thirdpartyurl                              = ''
  $customclient_desktop                       =	'http://owncloud.org/sync-clients/'
  $customclient_android                       = 'https://play.google.com/store/apps/details?id=com.owncloud.android'
  $customclient_ios                           = 'https://itunes.apple.com/us/app/owncloud/id543672169?mt=8'
  $appstoreenabled                            = true
  $appstoreurl                                = 'https://api.owncloud.com/v1'
  $appstore_experimental_enabled              = false
  $apps_paths                                 = 'array(array(\'path\'=> \'/var/www/owncloud/apps\',\'url\' => \'/apps\',\'writable\' => true,),)'
  $enable_previews                            = true
  $preview_max_x                              = 2048
  $preview_max_y                              = 2048
  $preview_max_scale_factor                   = 10
  $preview_max_filesize_image                 = 50
  $preview_libreoffice_path                   = '/usr/bin/libreoffice'
  $preview_office_cl_parameters               = ' --headless --nologo --nofirststartwizard --invisible --norestore -convert-to pdf -outdir '
  $enabledPreviewProviders                    = 'array(\'OC\Preview\PNG\',\'OC\Preview\JPEG\',\'OC\Preview\GIF\',\'OC\Preview\BMP\',\'OC\Preview\XBitmap\',\'OC\Preview\MP3\',\'OC\Preview\TXT\',\'OC\Preview\MarkDown\')'
  $ldapUserCleanupInterval                    = 51
  $comments_managerFactory                    = '\OC\Comments\ManagerFactory'
  $systemtags_managerFactory                  = '\OC\SystemTag\ManagerFactory'
  $maintenance                                = false
  $singleuser                                 = false
  $openssl                                    = 'array(\'config\' = \'/absolute/location/of/openssl.cnf\',)'
  $enable_certificate_management              = false
  $memcache_local                             = '\OC\Memcache\APCu'
  $memcache_distributed                       = '\OC\Memcache\Memcached'
  $redis                                      = 'array(\'host\' => \'localhost\' , \'port\' => 6379,\'timeout\' => 0.0,\'password\' => \'\', \'dbindex\' => 0,)'
  $memcached_servers                          = 'array(array(\'localhost\', 11211),)'
  $cache_path                                 = ''
  $objectstore                                = 'array(\'class\' => \'OC\\Files\\ObjectStore\\Swift\',\'arguments\' => array(\'username\' => \'facebook100000123456789\',\'password\' => \'Secr3tPaSSWoRdt7\',\'container\' => \'owncloud\',\'autocreate\' => true,\'region\' => \'RegionOne\',\'url\' => \'http://8.21.28.222:5000/v2.0\',\'tenantName\' => \'facebook100000123456789\',\'serviceName\' => \'swift\',\'urlType\' => \'internal\'),)'
  $sharing_managerFactory                     = '\OC\Share20\ProviderFactory'
  $dbdriveroptions                            = 'array(PDO::MYSQL_ATTR_SSL_CA => \'/file/path/to/ca_cert.pem\',)'
  $sqlite_journal_mode                        = 'DELETE'
  $supportedDatabases                         = 'array(\'sqlite\',\'mysql\',\'pgsql\',\'oci\',)'
  $tempdirectory                              = '/tmp/owncloudtemp'
  $hashingCost                                = 10
  $blacklisted_files                          = 'array(\'.htaccess\')'
  $share_folder                               = '/'
  $theme                                      = ''
  $cipher                                     = 'AES-256-CFB'
  $minimum_supported_desktop_version          = '1.7.0'
  $quota_include_external_storage             = false
  $filesystem_check_changes                   = 0
  $asset_pipeline_enabled                     = false
  $assetdirectory                             = '/var/www/owncloud'
  $mount_file                                 = '/var/www/owncloud/data/mount.json'
  $filesystem_cache_readonly                  = false
  $secret                                     = ''
  $trusted_proxies                            = 'array(\'203.0.113.45\', \'198.51.100.128\')'
  $forwarded_for_headers                      = 'array(\'HTTP_X_FORWARDED\', \'HTTP_FORWARDED_FOR\')'
  $max_filesize_animated_gifs_public_sharing  = 10
  $filelocking_enabled                        = true
  $memcache_locking                           = '\\OC\\Memcache\\Redis'
  $debug                                      = false
  $copied_sample_config                       = true
# control parameters
  $service_enable                             = true
  $service_ensure                             = 'running'
  $service_manage                             = true
  $service_name                               = 'apache2'
  $apt_url_community                          = 'community'
  $apt_url_enterprise                         = 'enterprise'
  $do_Update                                  = false
  $enterprise_community                       = false
  $fqdn                                       = undef
}
