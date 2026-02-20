# @summary
#  Class installs wireguard packages and sets yum repository
# 
# @api private
#
class wireguard::install (
  $package_name   = $wireguard::package_name,
  $base_url       = $wireguard::base_url,
  $gpg_key        = $wireguard::gpg_key,
  $repo_url       = $wireguard::repo_url,
  $manage_repo    = $wireguard::manage_repo,
  $manage_package = $wireguard::manage_package,
  $package_ensure = $wireguard::package_ensure,
) {
  assert_private()

  if $manage_repo {
    case $facts['os']['name'] {
      'RedHat', 'CentOS', 'VirtuozzoLinux', 'Fedora': {
        yumrepo { 'wireguard':
          ensure              => present,
          enabled             => true,
          baseurl             => $base_url,
          descr               => 'Wireguard',
          skip_if_unavailable => true,
          gpgcheck            => true,
          gpgkey              => $gpg_key,
          repo_gpgcheck       => false,
        }
      }
      default: {
        warning("Cannot manage WireGuard repo for OS: ${facts['os']['name']}! If it's Ubuntu or Debian, set \$manage_repo to false because WireGuard is in standard repos.")
      }
    }
  }

  case $facts['os']['name'] {
    'RedHat', 'CentOS', 'VirtuozzoLinux', 'Fedora': {
      if $manage_repo {
        # Repo was set via yumrepo resource
        $_require = Yumrepo['wireguard']
      } else {
        # Assume repo is already set up
        $_require = undef
      }
    }
    'Ubuntu', 'Debian': {
      # WireGuard is in standard repos - no repo setup needed
      $_require = undef
    }
    default: {
      $_require = undef
    }
  }

  if $manage_package {
    package { $package_name:
      ensure  => $package_ensure,
      require => $_require,
    }
  }
}
