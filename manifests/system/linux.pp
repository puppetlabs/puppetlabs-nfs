class nfs::system::linux {
  
  file {
    "${nfs::config::set_work_directory}":
      ensure  => directory,
      purge   => true,
      recurse => true;
    "${nfs::config::set_work_directory}/HEADER":
      content => $nfs::config::set_header,
      owner   => $nfs::config::set_file_owner,
      group   => $nfs::config::set_file_group,
      mode    => 0644;
    "${nfs::config::set_work_directory}/export_contents.rb":
      source => $puppetversion ? {
        /2\../   => 'puppet:///modules/nfs/linux_export_contents.rb',
        default => 'puppet:///nfs/linux_export_contents.rb'
      },
      mode   => 700,
      owner  => $nfs::config::set_file_owner,
      group  => $nfs::config::set_file_group;
  }
  
  #Execute the export_contents.rb script
  exec { 'rebuild exports':
    command => "${nfs::config::set_work_directory}/export_contents.rb apply ${nfs::config::set_work_directory}",
    unless  => "${nfs::config::set_work_directory}/export_contents.rb check ${nfs::config::set_work_directory}",
  }

  package { "${nfs::config::set_linux_package}":
    ensure => $nfs::config::set_linux_package_version,
  }

  #Set our relationships
  Package["${nfs::config::set_linux_package}"] -> Service['nfs']

  #Set notifications
  Exec['rebuild exports'] ~> Service['nfs']
}
