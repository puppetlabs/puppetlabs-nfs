define nfs::export (
  $export,
  $parameters = ['ro','subtree_check'],
  $host    = 'UNSET',
  $subnet  = 'UNSET',
  $network = 'UNSET',
  $offline = 'UNSET',
  $sec     = 'UNSET',
  $ro      = 'UNSET',
  $alldirs = 'UNSET',
  $maproot = 'UNSET',
  $mapall  = 'UNSET'
) {

  include nfs

  # Use name if we didn't get an export parameter
  $export_real = $export ? {
    'UNSET' => $name,
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
