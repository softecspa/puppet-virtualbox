class virtualbox(
  $version      = '4.3.12-93733',
  $tmp_dir      = '',
) {

  if $version !~ /^4\.3\.12/ {
    fail("only major version 4.3.12 is supported")
  }

  $minor_part = inline_template("<%= @version.split('-').at(-1) %>")
  $major_version = regsubst($version,"-${minor_part}",'')

  case $::operatingsystem {
    "windows":  {
      require cygwin

      if $tmp_dir == '' {
        fail('in windows env you have to specify a tmp_dir')
      }

      $source           = "http://download.virtualbox.org/virtualbox/${major_version}/VirtualBox-${version}-Win.exe"
      $filename         = "${tmp_dir}\\VirtualBox-${version}-Win.exe"
      $provider         = "windows"
      $install_options  = [ "--silent" ]
      $pkg_name         = "Oracle VM VirtualBox ${major_version}"
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

      package {$pkg_name:
        ensure          => $ensure,
        source          => $filename,
        provider        => $provider,
        install_options => $install_options,
        notify          => $notify
      }
    }

    'ubuntu': {
      $pkg_name         = 'virtualbox-4.3'
      $ensure           = present
      $source           = undef
      $provider         = 'apt'
      $install_options  = undef
      $notify           = undef

      $dependencies = $::lsbdistcodename?{
        'lucid'   => [ 'libvpx0' ],
        'precise' => [ 'libvpx1' ],
      }

      package {$dependencies :
        ensure  => present,
        before  => Deb::From_url[$pkg_name]
      }

      deb::from_url {$pkg_name :
        url     => "http://download.virtualbox.org/virtualbox/${major_version}/${pkg_name}_${version}~Ubuntu~${::lsbdistcodename}_${::architecture}.deb",
        version => $version
      }
    }
  }

  class {'virtualbox::extension_pack':
    tmp_dir => $tmp_dir
  }
}
