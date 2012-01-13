define nfs::system::darwin::exporthost (
  $export,
  $parameters,
  $host,
  $subnet = undef,
  $network = undef,
  $offline = undef,
  $sec = undef,
  $ro = undef,
  $alldirs = undef,
  $maproot = undef,
  $mapall = undef
) {

  #Default to namevar if host param not given
  $hostname = $host ? {
    undef   => $name,
    default => $host
  }

  variable_select($offline, '')

  #Since the export directory is an absolute path, we need to convert the slashes
  # to underscores to use the concat resource
  #$export_directory = inline_template("<%= export_directory.gsub('/', '_') %>")

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

  file { "${nfs::config::set_work_directory}/${title}.yaml":
    content => inline_template("<%= params.to_yaml %>"),
    owner   => $nfs::config::set_file_owner,
    group   => $nfs::config::set_file_group,
  }

  #Set our notifications
  File["${nfs::config::set_work_directory}/${title}.yaml"] ~> Exec['rebuild exports']

}
