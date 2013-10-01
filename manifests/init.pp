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
#
# === Copyright
#
# Copyright 2013 UnderGrid Network Services, unless otherwise noted.
#
class jenkins (
  $ensure              = present,
  $http_port           = '8080',
  $ajp_port            = '-1',
  $manage_package_repo = true,
) {

  validate_re   ($ensure,        ['^present$', '^absent$'])
  validate_re   ($http_port,     ['^\d+$', '^-1$'])
  validate_re   ($ajp_port,      ['^\d+$', '^-1$'])
  validate_bool ($manage_package_repo)

  if (!defined(Class['jenkins::repo']) and $manage_package_repo) {
    class { 'jenkins::repo': ensure => $ensure }
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

  package { 'jenkins':
    ensure      => $ensure,
  }->
  file_line { 'jenkins headless':
    path => '/etc/default/jenkins',
    line => 'JAVA_ARGS="-Djava.awt.headless=true"'
  }->
  file_line { 'jenkins http port':
    path => '/etc/default/jenkins',
    line => "HTTP_PORT=${http_port}",
  }->
  file_line { 'jenkins ajp port':
    path => '/etc/default/jenkins',
    line => "AJP_PORT=${ajp_port}",
  }~>
  service { 'jenkins':
    ensure      => $ensure_real,
    enable      => $enable_real,
    hasrestart  => false,
    hasstatus   => true,
    require     => Package['jenkins'],
  }
}
