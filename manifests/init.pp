# @summary
#   Wireguard class manages wireguard - an open-source software application
#   and protocol that implements virtual private network techniques to create
#   secure point-to-point connections in routed or bridged configurations.
# @see https://www.wireguard.com/
# @param package_name
#   Name the package(s) that installs wireguard
# @param base_url
#   Base URL for wireguard repo, if set it will be used instead of repo_url
# @param gpg_key
#   GPG key for wireguard repo
# @param manage_repo
#   Should class manage yum repo (only for RHEL based systems, for Debian/Ubuntu wireguard is in standard repos)
# @param manage_package
#   Should class install package(s)
# @param package_ensure
#   Set state of the package
# @param config_dir
#   Path to wireguard configuration files
# @param config_dir_mode
#   The config_dir access mode bits
# @param config_dir_purge
#   Whether to purge unmanaged files in the config_dir
# @param interfaces
#   Define wireguard interfaces
class wireguard (
  Variant[Array, String]                                 $package_name     = $wireguard::params::package_name,
  Boolean                                                $manage_repo      = $wireguard::params::manage_repo,
  Boolean                                                $manage_package   = $wireguard::params::manage_package,
  Variant[Boolean, Enum['installed','latest','present']] $package_ensure   = 'installed',
  Stdlib::Absolutepath                                   $config_dir       = $wireguard::params::config_dir,
  String                                                 $config_dir_mode  = $wireguard::params::config_dir_mode,
  Boolean                                                $config_dir_purge = $wireguard::params::config_dir_purge,
  String                                                 $base_url         = $wireguard::params::base_url,
  String                                                 $gpg_key          = $wireguard::params::gpg_key,
  Optional[Hash]                                         $interfaces       = {},
) inherits wireguard::params {
  contain wireguard::install
  contain wireguard::config

  Class['wireguard::install'] -> Class['wireguard::config']

  $interfaces.each |$name, $options| {
    wireguard::interface { $name:
      * => $options,
    }
  }
}
