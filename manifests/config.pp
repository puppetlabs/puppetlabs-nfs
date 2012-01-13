class nfs::config (
  $header         = 'UNSET',
  $work_directory = 'UNSET',
  $file_owner     = 'UNSET',
  $file_group     = 'UNSET',
  $linux_package  = 'UNSET',
  $nfs_service    = 'UNSET'
  $linux_package_version = 'UNSET'
) {

  include nfs::config::defaults
  
  $header_real = $header ? {
    'UNSET'   => $nfs::config::defaults::header,
    default => $header
  }

  $work_directory_real = $work_directory ? {
    'UNSET'   => $nfs::config::defaults::work_directory,
    default => $work_directory
  }

  $file_owner_real = $file_owner ? {
    'UNSET'   => $nfs::config::defaults::file_owner,
    default => $file_owner
  }

  $file_group_real = $file_group ? {
    'UNSET'   => $nfs::config::defaults::file_group,
    default => $file_group
  }

  $linux_package_real = $linux_package ? {
    'UNSET'   => $nfs::config::defaults::linux_package,
    default => $linux_package
  }

  $linux_package_version_real = $linux_package_version ? {
    'UNSET'   => $nfs::config::defaults::linux_package_version,
    default => $linux_package_version
  }

  $nfs_service_real = $nfs_service ? {
    'UNSET'   => $nfs::config::defaults::nfs_service,
    default => $nfs_service
  }

}
