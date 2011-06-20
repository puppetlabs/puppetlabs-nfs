define nfs::system::solaris::export (
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

  #This hash makes it easy to generate a yaml file to store the config on the node
  $params = {
    'resource_title' => $title,
    'export'         => $export,
    'parameters'     => $parameters,
    'host'           => $host,
    'subnet'         => $subnet,
  }

  file { "${nfs::config::set_work_directory}/${title}.yaml":
    content => inline_template("<%= params.to_yaml %>"),
    owner   => $nfs::config::set_file_owner,
    group   => $nfs::config::set_file_group,
  }

  #Set our notifications
  File["${nfs::config::set_work_directory}/${title}.yaml"] ~> Exec['rebuild exports']

}
