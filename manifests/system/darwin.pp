class nfs::system::darwin {

	file { 
		"${nfs::config::set_work_directory}/_00000_HEADER":
			content => $nfs::config::set_header,
			owner   => $nfs::config::set_file_owner,
			group		=> $nfs::config::set_file_group,
			mode    => 0644;
		"${nfs::config::set_work_directory}":
			ensure  => directory,
			purge   => true,
			recurse => true;
	}
	
	#Grab all the files starting with underscores
	exec { 'rebuild exports':
		command     => "/bin/cat ${nfs::config::set_work_directory}/_* > /etc/exports",
		refreshonly => true,
	}

	#Set our notifications
	File["${nfs::config::set_work_directory}/_00000_HEADER"] ~> Exec['rebuild exports']
	File[$nfs::config::set_work_directory] ~> Exec['rebuild exports']

}
