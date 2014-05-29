class virtualbox(
  $version      = '4.3.12',
  $tmp_dir      = '',
  $use_apt      = true
) {

  if $version !~ /^4\.3\./ {
    fail("only major version 4.3 is supported")
  }

  case $::operatingsystem {
    "windows":  {
      require cygwin

      $source           = "http://download.virtualbox.org/virtualbox/${version}/VirtualBox-${version}-93733-Win.exe"
      $filename         = "${tmp_dir}\\VirtualBox-${version}-93733-Win.exe"
      $provider         = "windows"
      $install_options  = [ "--silent" ]
      $pkg_name         = "Oracle VM VirtualBox ${version}"
      $ensure           = 'installed'
      $notify           = Exec['install extpack']


      cygwin::wget {$source:
        path    => $filename,
        before  => Package[$pkg_name],
      }

      windows_path{'virtualbox':
        ensure    => 'present',
        directory => 'C:\\Program Files\\Oracle\\VirtualBox',
        require   => Package[$pkg_name]
      }
    }

    'ubuntu': {
      $pkg_name         = 'virtualbox'
      $ensure           = latest
      $source           = undef
      $provider         = 'apt'
      $install_options  = undef
      $notify           = undef
    }
  }

  package {$pkg_name:
    ensure          => $ensure,
    source          => $filename,
    provider        => $provider,
    install_options => $install_options,
    notify          => $notify
  }

  class {'virtualbox::extension_pack':
    tmp_dir => $tmp_dir
  }
}
