set_unless[:elasticsearch][:version] = "0.8.0"
set_unless[:elasticsearch][:checksum] = '67a5b6240c27db666b5d2b48cdc26b91d64e8f2e950c6383273e47a6f4020da4'

set_unless[:elasticsearch][:cluster_name] = "default"

set_unless[:elasticsearch][:home] = "/usr/lib/elasticsearch"

set_unless[:elasticsearch][:s3_gateway_bucket] = nil # s3 bucket to store gateway snapshots in

set_unless[:elasticsearch][:heap_size] = 1000
set_unless[:elasticsearch][:fd_ulimit] = nil # nofiles limit (make this something like 32768, see /etc/security/limits.conf)

set_unless[:elasticsearch][:default_replicas] = 1 # replicas are in addition to the original, so 1 replica means 2 copies of each shard
set_unless[:elasticsearch][:default_shards] = 6 # 6*2 shards per index distributes evenly across 3, 4, or 6 nodes
