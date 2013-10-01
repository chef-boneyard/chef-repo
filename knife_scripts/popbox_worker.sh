#!/bin/sh
knife rackspace server create -f 3 --image 25a5f2e8-f522-4fe0-b0e0-dbaa62405c25 -S 'jwood-test-worker-a0' -E 'dev' -r 'role[barbican-worker]'
#knife rackspace server create -f 3 --image 25a5f2e8-f522-4fe0-b0e0-dbaa62405c25 -S 'jwood-test-worker-05' -E 'dev' -r 'role[base], role[worker], recipe[barbican-worker], role[aspects_base]'

                                                                         
