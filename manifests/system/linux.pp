class nfs::system::linux {
	
	file { 
		"${nfs::config::set_work_directory}/_00000_HEADER":
			content => $nfs::config::set_header,
			mode    => $nfs::config::set_file_owner,
			group		=> $nfs::config::set_file_group,
		"${nfs::config::set_work_directory}":
			ensure  => directory,
			purge   => true,
			recurse => true;
	}
	
	#Grab all the files starting with underscores
	exec { 'rebuild exports':
		command     => '/bin/cat ${nfs::config::set_work_directory}/_*',
		refreshonly => true,
	}

	package { "${nfs::config::set_linux_package}":
		ensure => $nfs::config::set_linux_package_version
	}
		
	#Set our relationships
	Package["${nfs::config::set_linux_package}"] -> Service['nfsd']

}
