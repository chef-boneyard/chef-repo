#!/bin/sh
knife rackspace server create -f 3 --image 25a5f2e8-f522-4fe0-b0e0-dbaa62405c25 -S 'test-queue-01' -E 'dev' -r 'role[base], role[queue], recipe[barbican-queue], role[aspects_base]'

                                                                         
