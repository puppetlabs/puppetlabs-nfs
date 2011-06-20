class nfs::system::darwin {

  file {
    "${nfs::config::set_work_directory}/HEADER":
      content => $nfs::config::set_header,
      owner   => $nfs::config::set_file_owner,
      group   => $nfs::config::set_file_group,
      mode    => 0640;
    "${nfs::config::set_work_directory}":
      ensure  => directory,
      purge   => true,
      recurse => true;
    "${nfs::config::set_work_directory}/export_contents.rb":
      source => $puppetversion ? {
        /2\../   => 'puppet:///modules/nfs/darwin_export_contents.rb',
        default => 'puppet:///nfs/darwin_export_contents.rb'
      },
      mode   => 700,
      owner  => $nfs::config::set_file_owner,
      group  => $nfs::config::set_file_group;
  }

  #Make sure the exports file is correct
  exec { 'rebuild exports':
    command => "${nfs::config::set_work_directory}/export_contents.rb apply ${nfs::config::set_work_directory}",
    unless  => "${nfs::config::set_work_directory}/export_contents.rb check ${nfs::config::set_work_directory}",
  }

  #Set our notifications
  File[$nfs::config::set_work_directory] ~> Exec['rebuild exports']
  Exec['rebuild exports'] ~> Service["${nfs::config::set_nfs_service}"]

}
