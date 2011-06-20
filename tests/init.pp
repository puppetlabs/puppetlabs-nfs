## THESE TESTS MODIFY THE SYSTEM

Nfs::Exporthost {
  parameters => ['rw','no_root_squash'],
}

# Create our export hosts
nfs::export { 'google.com':
  export => ['/exports/testa','/exports/testd'],
  ro     => true,
  mapall => nobody,
  host   => '',
}

nfs::export { 'google.com-testc':
  host       => ['google.com','yahoo.com'],
  export     => ['/exports/testc','/exports/testd'],
  parameters => ['ro'],
}
