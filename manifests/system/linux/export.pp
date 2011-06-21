define nfs::system::linux::export (
  $export,
  $parameters,
  $host,
  $subnet,
) {

  #This hash makes it easy to generate a yaml file to store the config on the node
  $params = {
    'resource_title' => $title,
    'export'         => $export,
    'parameters'     => $parameters,
    'host'           => $host,
    'subnet'         => $subnet,
  }

  file { "${nfs::config::work_directory_real}/${title}.yaml":
    content => inline_template("<%= params.to_yaml %>"),
    owner   => $nfs::config::file_owner_real,
    group   => $nfs::config::file_group_real,
  }

  #Set our notifications
  File["${nfs::config::work_directory_real}/${title}.yaml"] ~> Exec['rebuild exports']

}
