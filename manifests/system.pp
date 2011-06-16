class nfs::system {

  case $kernel {
    'Linux': {
      include nfs::system::linux
    }
    'Darwin': {
      include nfs::system::darwin
    }
    'Solaris': {
      include nfs::system::solaris
    }

    default: {
      fail "This module does not support ${kernel}"
    }
  }

  service { "${nfs::config::set_nfs_service}":
    alias  => nfs,
    ensure => running,
    enable => true,
  }

}
