#!/bin/sh
knife rackspace server create -f 3 --image 25a5f2e8-f522-4fe0-b0e0-dbaa62405c25 -S 'jwood-test-api-a0' -E 'dev' -r 'role[barbican-api]'
# knife rackspace server create -f 3 --image 25a5f2e8-f522-4fe0-b0e0-dbaa62405c25 -S 'jwood-test-api-06' -E 'dev' -r 'role[base], role[ntpd], role[auth_keys], role[api], recipe[barbican-api], role[aspects_base]'


                                                                         
