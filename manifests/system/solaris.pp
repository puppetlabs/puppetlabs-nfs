class nfs::system::linux {
  
  file {
    "${nfs::config::work_directory_real}":
      ensure  => directory,
      purge   => true,
      recurse => true;
    "${nfs::config::work_directory_real}/HEADER":
      content => $nfs::config::header_real,
      owner   => $nfs::config::file_owner_real,
      group   => $nfs::config::file_group_real,
      mode    => 0644;
    "${nfs::config::work_directory_real}/export_contents.rb":
      source => $puppetversion ? {
        /2\../   => 'puppet:///modules/nfs/solaris_export_contents.rb',
        default => 'puppet:///nfs/solaris_export_contents.rb'
      },
      mode   => 700,
      owner  => $nfs::config::file_owner_real,
      group  => $nfs::config::file_group_real;
  }
  
  #Execute the export_contents.rb script
  exec {
    'rebuild exports':
      command => "${nfs::config::work_directory_real}/export_contents.rb apply ${nfs::config::work_directory_real}",
      unless  => "${nfs::config::work_directory_real}/export_contents.rb check ${nfs::config::work_directory_real}";
    'reshare exports':
      command     => 'shareall',
      path        => '/sbin:/usr/sbin:/usr/local/sbin:/bin:/usr/bin:/usr/local/bin',
      refreshonly => true;
  }

  #Set notifications
  Exec['rebuild exports'] ~> Exec['reshare exports']
}
