class virtualbox::extension_pack (
  $version      = "4.3.12",
  $tmp_dir      = "C:\\vagrant-init\\tmp",
) {
  
  require virtualbox 

  if $version !~ /^4\.3\./ {
    fail("only major version 4.3 is supported")
  }

  case $::operatingsystem {
    "windows":  {
      $source           = "http://download.virtualbox.org/virtualbox/${version}/Oracle_VM_VirtualBox_Extension_Pack-${version}-93733.vbox-extpack"
      $filename         = "${tmp_dir}\\Oracle_VM_VirtualBox_Extension_Pack-${version}-93733.vbox-extpack"

        cygwin::wget {$source:
          path    => $filename,
          before  => Exec['install extpack']
        }
    }
  }

  exec {'install extpack':
    command     => "VBoxManage extpack install ${filename}",
    cwd         => 'C:\\Program Files\\Oracle\\VirtualBox',
    path        => "C:\\Program Files\\Oracle\\VirtualBox;${::path}",
    provider    => 'windows',
    refreshonly => true,
  }

}
