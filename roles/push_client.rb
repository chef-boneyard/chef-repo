name "push_client"
description "Role applied to all nodes running Chef Push jobs"
override_attributes(
  "push_jobs" => {
    "package_url" => "https://web-dl.packagecloud.io/chef/stable/packages/ubuntu/precise/opscode-push-jobs-client_1.1.5-1_amd64.deb",
    "package_checksum" => "d7b40ebb18c7c7dbc32322c9bcd721279e707fd1bee3609a37055838afbf67ea"
  }
)
run_list [ "push-jobs" ]
