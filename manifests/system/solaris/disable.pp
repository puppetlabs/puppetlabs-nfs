class nfs::system::solaris::disable {
  exec { 'unshare exports':
    command     => 'unshareall',
    path        => '/sbin:/usr/sbin:/usr/local/sbin:/bin:/usr/bin:/usr/local/bin',
    refreshonly => true,
  }
}
