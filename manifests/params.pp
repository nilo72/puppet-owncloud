#
# Global parameters for owncloud installations
#
class owncloud::params(
  $owncloud_db_password = undef,
  $owncloud_node_ips    = undef,
  $root_db_password     = undef,
  $passwordsalt         = undef,
  $secret               = undef,
  $trusted_domains      = undef,
  $datadirectory        = undef,
  $baseurl              = undef,
  $dbtype               = undef,
  $dbname               = undef,
  $dbhost               = undef,
  $apphostip            = undef,
  $dbtableprefix        = 'oc_',
  $is_backup_host       = false,
  $dbuser               = undef,
  $nfs_host_ip          = undef
){
}
