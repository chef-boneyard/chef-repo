name "nfs_server"
description "Role applied to the system that should be an NFS server."
override_attributes(
  "nfs" => {
    "packages" => [ "portmap", "nfs-common", "nfs-kernel-server" ],
    "port" => {
      "statd" => 32765,
      "statd_out" => 32766,
      "mountd" => 32767,
      "lockd" => 32768
    },
    "export" => {
      "dir" => "/exports",
      "network" => "10.0.0.0/8",
      "writeable" => false,
      "sync" => true,
      "options" => [ "no_root_squash" ]
    }  
  }
)
run_list [ "emulab-nfs::export" ]
