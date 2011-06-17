class nfs::system::disable inherits nfs::system {
	
	Service["${nfs::config::set_nfs_service}"] {
		ensure => stopped,
		enable => false,
	}

}
