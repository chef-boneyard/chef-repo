default[:elasticsearch][:version] = "0.17.1"
default[:elasticsearch][:checksum] = '67a5b6240c27db666b5d2b48cdc26b91d64e8f2e950c6383273e47a6f4020da4'
default[:elasticsearch][:datadir] = '/var/lib/elasticsearch/data'

default[:elasticsearch][:cluster_name] = "default"

default[:elasticsearch][:home] = "/usr/lib/elasticsearch"

default[:elasticsearch][:s3_gateway_bucket] = nil # s3 bucket to store gateway snapshots in

default[:elasticsearch][:heap_size] = 1000
default[:elasticsearch][:fd_ulimit] = nil # nofiles limit (make this something like 32768, see /etc/security/limits.conf)

default[:elasticsearch][:default_replicas] = 1 # replicas are in addition to the original, so 1 replica means 2 copies of each shard
default[:elasticsearch][:default_shards] = 6 # 6*2 shards per index distributes evenly across 3, 4, or 6 nodes

default[:elasticsearch][:startup_timeout]   = 300
default[:elasticsearch][:shutdown_timeout]  = 300
default[:elasticsearch][:ping_timeout]      = 300
default[:elasticsearch][:java_command]      = "java"

default[:elasticsearch][:wrapper_name]      = "ElasticSearch"

default[:elasticsearch][:path_work] = "/var/lib/elasticsearch/work"
default[:elasticsearch][:path_logs] = "/var/log/elasticsearch"

default[:elasticsearch][:http_enabled] = true
default[:elasticsearch][:node_data] = true
default[:elasticsearch][:recovery_after_nodes] = 1
default[:elasticsearch][:recovery_after_time] = 5m
default[:elasticsearch][:expected_nodes] = 2
default[:elasticsearch][:gateway_fs_location] = "/var/lib/elasticsearch/gateway"
