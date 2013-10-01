# == Class: jenkins
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
# Original fork: https://github.com/rdegges/puppet-jenkins
#
# === Copyright
#
# Copyright 2013 UnderGrid Network Services, unless otherwise noted.
#
class jenkins (
  $ensure = present
) {

  if !defined(Class['jenkins::repo']) {
    class { 'jenkins::repo': ensure => $ensure }
  }

  package { 'jenkins':
    ensure      => $ensure,
  }

  case $ensure {
    absent: {
      $enable_real = false
      $ensure_real = stopped
    }
    default: {
      $enable_real = true
      $ensure_real = running
    }
  }

  service { 'jenkins':
    ensure      => $ensure_real,
    enable      => $enable_real,
    hasrestart  => true,
    hasstatus   => true,
    require     => Package['jenkins'],
  }
}
