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
        /2\../   => 'puppet:///modules/nfs/solaris_export_contents.rb',
        default => 'puppet:///nfs/solaris_export_contents.rb'
      },
      mode   => 700,
      owner  => $nfs::config::set_file_owner,
      group  => $nfs::config::set_file_group;
  }
  
  #Execute the export_contents.rb script
  exec {
    'rebuild exports':
      command => "${nfs::config::set_work_directory}/export_contents.rb apply ${nfs::config::set_work_directory}",
      unless  => "${nfs::config::set_work_directory}/export_contents.rb check ${nfs::config::set_work_directory}";
    'reshare exports':
      command     => 'shareall',
      path        => '/sbin:/usr/sbin:/usr/local/sbin:/bin:/usr/bin:/usr/local/bin',
      refreshonly => true;
  }

  #Set notifications
  Exec['rebuild exports'] ~> Exec['reshare exports']
}
