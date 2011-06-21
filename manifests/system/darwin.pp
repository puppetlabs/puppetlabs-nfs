class nfs::system::darwin {

  file {
    "${nfs::config::work_directory_real}":
      ensure  => directory,
      purge   => true,
      recurse => true;
    "${nfs::config::work_directory_real}/HEADER":
      content => $nfs::config::header_real,
      owner   => $nfs::config::file_owner_real,
      group   => $nfs::config::file_group_real,
      mode    => 0640;
    "${nfs::config::work_directory_real}/export_contents.rb":
      source => $puppetversion ? {
        /2\../   => 'puppet:///modules/nfs/darwin_export_contents.rb',
        default => 'puppet:///nfs/darwin_export_contents.rb'
      },
      mode   => 700,
      owner  => $nfs::config::file_owner_real,
      group  => $nfs::config::file_group_real;
  }

  #Make sure the exports file is correct
  exec { 'rebuild exports':
    command => "${nfs::config::work_directory_real}/export_contents.rb apply ${nfs::config::work_directory_real}",
    unless  => "${nfs::config::work_directory_real}/export_contents.rb check ${nfs::config::work_directory_real}",
  }

  #Set our notifications
  File[$nfs::config::work_directory_real] ~> Exec['rebuild exports']
  Exec['rebuild exports'] ~> Service["${nfs::config::nfs_service_real}"]

}
