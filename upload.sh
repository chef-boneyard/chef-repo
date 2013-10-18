#!/bin/sh
# Script to upload information from this repository to a Chef Server (configured in your knife.rb file).

# Install cookbooks/updates into the .berkself folder structure.
berks install

# Upload roles files.
knife role from file roles/*.rb

# Upload environment files.
knife environment from file environments/*.json

# Upload data bag files. -- Don't do this as it can overwrite or expose sensitive data!
# 

# Upload Berkshelf-derived cookbooks.
berks upload

# Upload custom cookbooks.
knife cookbook upload barbican-base
knife cookbook upload barbican-api
knife cookbook upload barbican-db
knife cookbook upload barbican-queue
knife cookbook upload barbican-worker
knife cookbook upload chef-cloudpassage
knife cookbook upload authorized_keys
                                                                        
