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


      cygwin::wget {$source:
        path    => $filename,
        before  => Package[$pkg_name],
      }

      windows_path{'virtualbox':
        ensure    => 'present',
        directory => 'C:\Program Files\Oracle\VirtualBox',
        require   => Package[$pkg_name]
      }
    }

    'ubuntu': {
      $source           = $use_apt?{
        true  => undef,
        false => "http://download.virtualbox.org/virtualbox/${version}/virtualbox-4.3_${version}-93733~Ubuntu~${::lsbdistcodename}_${::architecture}.deb"
      }
      $filename         = "${tmp_dir}/virtualbox-4.3_${version}-93733~Ubuntu~${::lsbdistcodename}_${::architecture}.deb"
      $provider         = $use_apt?{
        true  => 'apt',
        false => 'dpkg'
      }
      $install_options  = undef
      $pkg_name         = 'virtualbox'
      $ensure           = $use_apt?{
        true  => $version,
        false => 'installed'
      }

      if !$use_apt {
        exec {'download virtualbox deb':
          command => "wget $source -O $filename",
          creates => $filename,
          path    => $::path,
          before  => Package[$pkg_name]
        }
      }
    }
  }

  package {$pkg_name:
    ensure          => $ensure,
    source          => $filename,
    provider        => $provider,
    install_options => $install_options,
    notify          => Exec['install extpack'],
  }

  #class {'virtualbox::extension_pack':
  #  tmp_dir => $tmp_dir
  #}
}
