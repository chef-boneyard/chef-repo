#!/bin/sh
# Script to upload information from this repository to a Chef Server (configured in your knife.rb file).

# Upload roles files.
knife role from file roles/*.rb

# Upload Berkshelf-derived cookbooks.
berks upload

# Upload custom cookbooks.
knife cookbook upload barbican-base
knife cookbook upload barbican-api
knife cookbook upload barbican-db
knife cookbook upload barbican-queue
                                                                        
