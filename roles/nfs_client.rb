name "nfs_client"
description "Role applied to the system(s) that should act as NFS client(s)."
override_attributes(
  "nfs" => {
    "mount" => {
      "dir" => "/imports",
      "source" => "head:/exports",
      "options" => "ro"
    }  
  }
)
run_list [ "emulab-nfs::mount" ]
