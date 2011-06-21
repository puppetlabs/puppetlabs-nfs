define nfs::system::darwin::export (
  $export,
  $parameters,
  $host,
  $subnet,
  $network,
  $offline,
  $sec,
  $ro,
  $alldirs,
  $maproot,
  $mapall
) {

  #This hash makes it easy to generate a yaml file to store the config on the node
  $params = {
    'resource_title' => $title,
    'export'         => $export,
    'parameters'     => $parameters,
    'host'           => $host,
    'subnet'         => $subnet,
    'network'        => $network,
    'offline'        => $offline,
    'sec'            => $sec,
    'ro'             => $ro,
    'alldirs'        => $alldirs,
    'maproot'        => $maproot,
    'mapall'         => $mapall
  }

  file { "${nfs::config::work_directory_real}/${title}.yaml":
    content => inline_template("<%= params.to_yaml %>"),
    owner   => $nfs::config::file_owner_real,
    group   => $nfs::config::file_group_real,
  }

  #Set our notifications
  File["${nfs::config::work_directory_real}/${title}.yaml"] ~> Exec['rebuild exports']

}
