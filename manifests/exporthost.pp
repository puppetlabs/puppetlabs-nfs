define nfs::exporthost (
	$export,
	$parameters = ['ro','subtree_check'],
	$host = undef,
	$subnet = undef
) {

  include nfs

  #Default to namevar if host param not given
  $set_host = $host ? {
    undef   => $name,
    default => $host
  }

	# Use name if we didn't get an export parameter
	$export_directory = $export ? {
		undef   => $name,
		default => $export
	}

	case $kernel {
		'Linux': {
			nfs::system::linux::exporthost { $title:
				export     => $export_directory,
				parameters => $parameters,
				host       => $set_host,
				subnet     => $subnet,
			}
		}
		'Darwin': {
			nfs::system::darwin::exporthost { $title:
				export     => $export_directory,
				parameters => $parameters,
				host       => $set_host,
				subnet     => $subnet,
			}
		}
		'Solaris': {
			nfs::system::solaris::exporthost { $title:
				export     => $export_directory,
				parameters => $parameters,
				host       => $set_host,
				subnet     => $subnet,
			}
		}

		default: {
			fail "This module does not support ${kernel}"
		}
	}

}
