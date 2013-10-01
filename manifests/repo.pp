# == Class: jenkins::repo
#
# === Parameters
#
# === Variables
#
# === Examples
#
# === Authors
#
# Jeremy T. Bouse <Jeremy.Bouse@UnderGrid.net>
#
# === Copyright
#
# Copyright 2013 UnderGrid Network Services, unless otherwise noted.
#
class jenkins::repo (
  $ensure = present,
) {
  case $::osfamily {
    'Debian': {
      Apt::Source {
        location    => 'http://pkg.jenkins-ci.org/debian',
        include_src => false,
        key         => 'D50582E6',
        key_source  => 'http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key',
      }
      apt::source { 'jenkins-ci.org':
        ensure  => $ensure,
        release => '',
        repos   => 'binary/',
      }
    }
    'RedHat', 'Linux': {
      $enabled = $ensure ? {
        absent  => '0',
        default => '1',
      }
      yumrepo { 'jenkins-ci.org':
        baseurl  => 'http://pkg.jenkins-ci.org/redhat',
        descr    => 'Jenkins-CI',
        enabled  => $enabled,
        gpgcheck => '1',
        gpgkey   => 'http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key',
      }
    }
    default: {
      fail("Unsupported managed repository for osfamily: ${::osfamily}")
    }
  }
}
