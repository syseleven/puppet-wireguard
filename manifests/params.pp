# @summary
#  Class that contains OS specific parameters for other classes
class wireguard::params {
  $config_dir_mode    = '0700'
  $config_dir_purge   = false
  $manage_package     = true
  $config_dir         = '/etc/wireguard'
  $gpg_key            = 'https://download.copr.fedorainfracloud.org/results/jdoss/wireguard/pubkey.gpg'
  case $facts['os']['name'] {
    'RedHat', 'CentOS', 'VirtuozzoLinux': {
      $manage_repo    = true
      $package_name   = ['wireguard-dkms', 'wireguard-tools']
      $base_url       = "https://download.copr.fedorainfracloud.org/results/jdoss/wireguard/epel-${facts['os']['release']['major']}-\$basearch/"
    }
    'Fedora': {
      $manage_repo    = true
      $package_name   = ['wireguard-dkms', 'wireguard-tools']
      $base_url       = 'https://download.copr.fedorainfracloud.org/results/jdoss/wireguard/fedora-$releasever-$basearch/'
    }
    'Ubuntu', 'Debian': {
      $manage_repo    = false
      $package_name   = ['wireguard', 'wireguard-tools']
    }
    default: {
      $manage_repo    = false
      $package_name   = 'wireguard'
    }
  }
}
