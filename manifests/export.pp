define nfs::export ( 
	$export = undef, 
	$manage_directory = false
) {

	include nfs

	# Use name if we didn't get an export parameter
	$export_directory = $export ? {
		undef   => $name,
		default => $export
	}

	case $kernel {
		'Linux': {
			nfs::system::linux::export { $name:
				export           => $export_directory,
				manage_directory => $manage_directory,
			}
		}
		'Darwin': {
			nfs::system::darwin::export { $name:
				export           => $export_directory,
				manage_directory => $manage_directory,
			}
		}
		'Solaris': {
			nfs::system::solaris::export { $name:
				export           => $export_directory,
				manage_directory => $manage_directory,
			}
		}

		default: {
			fail "This module does not support ${kernel}"
		}
	}

}
