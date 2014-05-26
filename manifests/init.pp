class virtualbox(
  $version      = "4.3.12",
  $tmp_dir      = "C:\\vagrant-init\\tmp"
) {

  require cygwin

  if $version !~ /^4\.3\./ {
    fail("only major version 4.3 is supported")
  }

  case $::operatingsystem {
    "windows":  {
      $source           = "http://download.virtualbox.org/virtualbox/${version}/VirtualBox-${version}-93733-Win.exe"
      $filename         = "${tmp_dir}\\VirtualBox-${version}-93733-Win.exe"
      $provider         = "windows"
      $install_options  = [ "--silent" ]


      cygwin::wget {$source:
        path    => $filename,
        before  => Package["Oracle VM VirtualBox ${version}"],
      }
    }
  }

  package {"Oracle VM VirtualBox ${version}":
    ensure          => installed,
    source          => $filename,
    provider        => $provider,
    install_options => $install_options,
    notify          => Exec['install extpack'],
  }

  windows_path{'virtualbox':
    ensure    => 'present',
    directory => 'C:\Program Files\Oracle\VirtualBox',
    require   => Package["Oracle VM VirtualBox ${version}"]
  }

  class {'virtualbox::extension_pack':
    tmp_dir => $tmp_dir
  }
}
