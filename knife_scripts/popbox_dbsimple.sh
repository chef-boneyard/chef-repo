#!/bin/sh
knife rackspace server create -f 3 --image 25a5f2e8-f522-4fe0-b0e0-dbaa62405c25 -S 'jwood-test-dbsimple-05' -E 'dev' -r 'role[barbican-db]'
# Popped, but no cp made no difference...and postgres was at 8.x...knife rackspace server create -f 3 --image 25a5f2e8-f522-4fe0-b0e0-dbaa62405c25 -S 'jwood-test-dbsimple-no-cp-2' -E 'dev' -r 'role[base], role[db], recipe[postgresql], recipe[postgresql::server], recipe[database::postgresql], recipe[database], recipe[barbican-db]'
# Works, with cloudpassage: knife rackspace server create -f 3 --image 25a5f2e8-f522-4fe0-b0e0-dbaa62405c25 -S 'jwood-test-dbsimple-04' -E 'dev' -r 'role[base], role[db], recipe[postgresql], recipe[postgresql::server], recipe[database::postgresql], recipe[database], recipe[barbican-db], role[aspects_base]'
                                                                         
