define nfs::system::linux::export (
	$export,
	$manage_directory
) {

	#Since the export directory is an absolute path, we need to convert the slashes
	# to underscores to create a directory
	$export_directory = inline_template("<%= export.gsub('/', '_') %>")

	#This directory exists solely to catch duplicate resources of export/host combinations
	file { "${nfs::config::set_work_directory}/${export_directory}":
		ensure => directory;
	}

	#Make sure the export directory exists if we were asked to
	if $manage_directory == true {
		file { $export: ensure => directory }
	}

}
