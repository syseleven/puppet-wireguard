# @summary
#  Class configures files and directories for wireguard
# @api private
#
class wireguard::config (
  $config_dir       = $wireguard::config_dir,
  $config_dir_mode  = $wireguard::config_dir_mode,
  $config_dir_purge = $wireguard::config_dir_purge,
) {
  assert_private()

  if $config_dir_purge {
    file { $config_dir:
      ensure  => 'directory',
      mode    => $config_dir_mode,
      owner   => 'root',
      group   => 'root',
      force   => true,
      recurse => true,
      purge   => true,
    }
  } else {
    file { $config_dir:
      ensure => 'directory',
      mode   => $config_dir_mode,
      owner  => 'root',
      group  => 'root',
    }
  }
}
