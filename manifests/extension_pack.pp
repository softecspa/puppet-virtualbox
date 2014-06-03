class virtualbox::extension_pack (
  $version      = "4.3.12-93733",
  $tmp_dir      = '',
) {

  require virtualbox

  $minor_part = inline_template("<%= @version.split('-').at(-1) %>")
  $major_version = regsubst($version,"-${minor_part}",'')

  if $version !~ /^4\.3\.12/ {
    fail("only major version 4.3.12 is supported")
  }

  $source           = "http://download.virtualbox.org/virtualbox/${major_version}/Oracle_VM_VirtualBox_Extension_Pack-${version}.vbox-extpack"

  case $::operatingsystem {
    "windows":  {
      $filename         = "${tmp_dir}\\Oracle_VM_VirtualBox_Extension_Pack-${version}.vbox-extpack"

      cygwin::wget {$source:
        path    => $filename,
        before  => Exec['install extpack']
      }

      exec {'install extpack':
        command     => "VBoxManage extpack install ${filename}",
        cwd         => 'C:\\Program Files\\Oracle\\VirtualBox',
        path        => "C:\\Program Files\\Oracle\\VirtualBox;${::path}",
        provider    => 'windows',
        refreshonly => true,
      }
    }
    'ubuntu': {
      $filename = "${tmp_dir}/Oracle_VM_VirtualBox_Extension_Pack-${version}.vbox-extpack"

      exec {'wget extension pack':
        command => "wget ${source} --output-document=${filename}",
        creates => $filename,
        unless  => 'VBoxManage list extpacks | grep \'Oracle VM VirtualBox Extension Pack\'',
        path    => $::path
      }

      exec {'install extension pack':
        command => "VBoxManage extpack install ${filename}",
        unless  => 'VBoxManage list extpacks | grep \'Oracle VM VirtualBox Extension Pack\'',
        notify  => Exec['rm extpack'],
        path    => $::path,
        require => Exec['wget extension pack']
      }

      exec {'rm extpack':
        command     => "rm ${filename}",
        refreshonly => true,
        path        => $::path
      }
    }
  }
}
