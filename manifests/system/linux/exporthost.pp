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

	$subnet_string = $subnet ? {
		undef   => '',
		default => "/$subnet"
	}

	$parameters_string = inline_template("<%= parameters.to_a.join(',') %>")
	
	concat::fragment{"${export_directory}-${set_host}":
		target  => "${nfs::config::set_work_directory}/${export_directory}",
		content => "${set_host}${subnet_string}(${parameters_string})\t",
		order   => 20,
	}

}
