class nfs::system::disable inherits nfs::system {
  
  Service['nfs'] {
    ensure => stopped,
    enable => false,
  }

}
