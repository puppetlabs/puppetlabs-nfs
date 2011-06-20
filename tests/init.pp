## THESE TESTS MODIFY THE SYSTEM

Nfs::Exporthost {
  parameters => ['rw','no_root_squash'],
}

# Define a custom header
#class { 'nfs::config': 
# header => '# My custom header' 
#}

# Create our exports
#nfs::export { ['/export/testa','/export/testb']: }

#nfs::export { '/export/testc': manage_directory => true }

# Create our export hosts
nfs::exporthost { 'google.com':
    export => '/exports/testa',
    ro    => true,
    mapall => nobody,
    host   => '',
}

nfs::exporthost { 'google.com-testc':
    host       => '',
  export     => '/exports/testc',
  parameters => ['ro'],
}

nfs::exporthost { 'foobar01-testc':
  export => '/exports/testb',
  host   => 'puppetnode01',
}

nfs::exporthost { 'testd':
  export => '/exports/testd',
  host   => 'puppetnode01',
}

