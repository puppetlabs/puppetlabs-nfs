## THESE TESTS MODIFY THE SYSTEM

Nfs::Exporthost {
	parameters => ['rw','no_root_squash'],
}

# Define a custom header
class { 'nfs::config': 
	header => '# My custom header' 
}

# Create our exports
nfs::export { ['/export/testa','/export/testb']: }

nfs::export { '/export/testc': manage_directory => true }


# Create our export hosts
nfs::exporthost { 'foobar':
	export	=> '/export/testa',
}

nfs::exporthost { 'foobar01':
	export     => '/export/testb',
	parameters => ['ro'],
}

#nfs::exporthost { 'foobar01-testc':
#	export => '/export/testc',
#	host	 => 'puppetnode01',
#}
