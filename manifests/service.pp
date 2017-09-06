# == Class: sssd::service
#
# Control the SSSD services
#
# == Authors
#
# * Trevor Vaughan <mailto:tvaughan@onyxpoint.com>
#
class sssd::service {

  case $facts['os']['name'] {
    'RedHat','CentOS': {
      file { '/etc/init.d/sssd':
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0754',
        seltype => 'sssd_initrc_exec_t',
        source  => 'puppet:///modules/sssd/sssd.sysinit',
        notify  => Service['sssd']
      }
    }
    'Debian','Ubuntu': {
      file { '/etc/init.d/sssd':
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0754',
        seltype => 'sssd_initrc_exec_t',
        source  => 'puppet:///modules/sssd/debian/sssd.sysinit',
        notify  => Service['sssd']
      }
      file { '/etc/default/sssd':
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0640',
        source  => 'puppet:///modules/sssd/debian/sssd.default',
        notify  => Service['sssd']
      }
    }
    default: {
      fail("${::operatingsystem} is not yet supported by ${module_name}")
    }
   }

  service { 'nscd':
    ensure => 'stopped',
    enable => false,
    notify => Service['sssd']
  }

  service { 'sssd':
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => File['/etc/init.d/sssd']
  }
}
