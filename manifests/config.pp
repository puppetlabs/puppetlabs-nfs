class nfs::config (
	$header = undef,
	$work_directory = undef,
	$file_owner = undef,
	$file_group = undef,
	$linux_package = undef,
	$linux_package_version = undef,
	$nfs_service = undef
) {

	include nfs::config::defaults
	
	#$set_header = variable_select($header, $nfs::config::defaults::header)
	$set_header = $header ? {
		undef   => $nfs::config::defaults::header,
		default => $header
	}

	$set_work_directory = $work_directory ? {
		undef   => $nfs::config::defaults::work_directory,
		default => $work_directory
	}

	$set_file_owner = $file_owner ? {
		undef   => $nfs::config::defaults::file_owner,
		default => $file_owner
	}

	$set_file_group = $file_group ? {
		undef   => $nfs::config::defaults::file_group,
		default => $file_group
	}

	$set_linux_package = $linux_package ? {
		undef 	=> $nfs::config::defaults::linux_package,
		default => $linux_package
	}

	$set_linux_package_version = $linux_package_version ? {
		undef   => $nfs::config::defaults::linux_package_version,
		default => $linux_package_version
	}

	$set_nfs_service = $nfs_service ? {
		undef   => $nfs::config::defaults::nfs_service,
		default => $nfs_service
	}

}
