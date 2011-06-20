class nfs::system::disable inherits nfs::system {
  
  Service['nfs'] {
    ensure => stopped,
    enable => false,
  }

  if $kernel == 'Solaris' {
    include nfs::system::solaris::disable

    Service["${nfs::config::set_nfs_service}"] ~> Exec['unshare exports']
  }
}
