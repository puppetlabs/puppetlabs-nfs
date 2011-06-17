define nfs::system::darwin::exporthost (
	$export,
	$parameters,
	$host,
	$subnet = undef
) {

  #Default to namevar if host param not given
  $hostname = $host ? {
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

  concat::fragment{"${export}-${hostname}":
    target  => "${nfs::config::set_work_directory}/${export_directory}",
    content => "${hostname}${subnet_string}(${parameters_string})\t",
    order   => 20,
  }

}
