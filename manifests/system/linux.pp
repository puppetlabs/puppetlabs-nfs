class nfs::system::linux {
	
	file { 
		"${nfs::config::set_work_directory}/_00000_HEADER":
			content => $nfs::config::set_header,
			owner   => $nfs::config::set_file_owner,
			group   => $nfs::config::set_file_group;
		"${nfs::config::set_work_directory}":
			ensure  => directory,
			purge   => true,
			recurse => true;
	}
	
	$cat_cmd = "cat ${nfs::config::set_work_directory}/_* "

	#Grab all the files starting with underscores and cat them to the exports file
	#Also overwrite the exports file if it doesn't have the correct content
	exec { 'rebuild exports':
		command => "${cat_cmd} > /etc/exports",
		unless  => "test \"`${cat_cmd} | md5sum | cut -d' ' -f1`\" = \"`md5sum /etc/exports | cut -d' ' -f1`\"",
		path    => '/bin:/usr/bin:/usr/local/bin',
		creates => ['/etc/exports'],
	}

	package { "${nfs::config::set_linux_package}":
		ensure => $nfs::config::set_linux_package_version,
	}

	#Set our relationships
	Package["${nfs::config::set_linux_package}"] -> Service['nfs']

	#Set notifications
	Exec['rebuild exports'] ~> Service['nfs']
}
