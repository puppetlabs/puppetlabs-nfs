define nfs::system::linux::export (
	$export,
	$manage_directory
) {

	#Since the export directory is an absolute path, we need to convert the slashes
	# to underscores to create a directory
	$export_directory = inline_template("<%= export.gsub('/', '_') %>")

	#This directory exists solely to catch duplicate resources of export/host combinations
  #This could be done in the Exec['rebuild exports'] script, but the user wouldn't see
	#	where in their manifest the duplicate resource was occurring
	file { "${nfs::config::set_work_directory}/${export_directory}":
		ensure => directory;
	}

	#Make sure the export directory exists if we were asked to
	if $manage_directory == true {
		file { $export: ensure => directory }
	}

}
