Nfs::Exporthost {
	parameters => ['rw','no_root_squash'],
}

class { 'nfs::config': header => 'yo' }

nfs::export { ['/tmp','/tmp/a']: }

nfs::export { '/tmp/b': manage_directory => true }

nfs::exporthost { 'myhost':
	export	=> '/tmp',
}

nfs::exporthost { 'myhostb':
	export     => '/tmp',
	parameters => ['ro'],
}

nfs::exporthost { 'myhostb-tmpa':
	export => '/tmp/a',
	host	 => myhostb,
}

