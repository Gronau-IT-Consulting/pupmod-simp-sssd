# == Class: sssd::install::client
#
# Install the sssd-client package
#
class sssd::install::client (
  $ensure = 'latest'
){
  if $facts['os']['name'] in ['RedHat','CentOS'] {
    $_package = 'sssd-client'
  }
  elsif $facts['os']['name'] in ['Debian','Ubuntu'] {
    $_package = 'sssd-common'
  }
  else {
    fail("OS '${facts['os']['name']}' not supported by '${module_name}'")
  }

  package { $_package: ensure => $ensure }
}
