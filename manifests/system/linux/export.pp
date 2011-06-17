define nfs::system::linux::export ( 
	$export, 
	$manage_directory
) {

	include concat::setup

	#Since the export directory is an absolute path, we need to convert the slashes
	# to underscores to use the concat resource
	$export_directory = inline_template("<%= export_directory.gsub('/', '_') %>")

	concat { "${nfs::config::set_work_directory}/${export_directory}":
		owner  => $nfs::config::set_file_owner,
		group  => $nfs::config::set_file_group,
		mode   => 0644,
		notify => Exec['rebuild exports'],
	}
	
	concat::fragment { $export_directory:
		target  => "${nfs::config::set_work_directory}/${export_directory}",
		content => "\n${export_directory}\t",
		order   => 10,
	}

	#Make sure the export directory exists if we were asked to
	if $manage_directory == true {
		file { $export: ensure => directory }
	}

}
