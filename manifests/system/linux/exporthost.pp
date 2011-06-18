define nfs::system::linux::exporthost (
	$export,
	$parameters,
	$host,
	$subnet = undef
) {

	#Default to namevar if host param not given
	$set_host= $host ? {
		undef   => $name,
		default => $host
	}
     
	#Since the export directory is an absolute path, we need to convert the slashes
	# to underscores to use the concat resource
	$export_directory = inline_template("<%= export_directory.gsub('/', '_') %>")

	#This hash makes it easy to generate a yaml file to store the config on the node
	$params = {
		'export'     => $export,
		'parameters' => $parameters,
		'host'       => $host,
		'subnet'     => $subnet,
	}

	file { "${nfs::config::set_work_directory}/${export_directory}/$host.yaml":
		content => inline_template("<%= params.to_yaml %>"),
		owner		=> $nfs::config::set_file_owner,
		group   => $nfs::config::set_file_group,
	}

	#Set our notifications
	File["${nfs::config::set_work_directory}/${export_directory}/$host.yaml"] ~> Exec['rebuild exports']

}
