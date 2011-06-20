define nfs::export (
  $export,
  $parameters = ['ro','subtree_check'],
  $host = undef,
  $subnet = undef,
  $network = undef,
  $offline = undef,
  $sec = undef,
  $ro = undef,
  $alldirs = undef,
  $maproot = undef,
  $mapall = undef
) {

  include nfs

  #Default to namevar if host param not given
  $set_export = $export ? {
    undef   => $name,
    default => $export
  }

  # Use name if we didn't get an export parameter
  $export_real = $export ? {
    undef   => $name,
    default => $export
  }

  case $kernel {
    'Linux': {
      nfs::system::linux::export { $title:
        export     => $export_real,
        parameters => $parameters,
        host       => $host,
        subnet     => $subnet,
      }
    }
    'Darwin': {
      nfs::system::darwin::export { $title:
        export       => $export_real,
        parameters   => $parameters,
        host         => $host,
        subnet       => $subnet,
        network      => $network,
        offline      => $offline,
        sec          => $sec,
        ro           => $ro,
        alldirs      => $alldirs,
        maproot      => $maproot,
        mapall       => $mapall,
      }
    }
    'Solaris': {
      nfs::system::solaris::export { $title:
        export     => $export_real,
        parameters => $parameters,
        host       => $host,
        subnet     => $subnet,
      }
    }

    default: {
      fail "This module does not support ${kernel}"
    }
  }

}
