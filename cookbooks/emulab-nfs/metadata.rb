name             'emulab-nfs'
maintainer       'Dmitry Duplyakin'
maintainer_email 'dmitry.duplyakin@colorado.edu'
license          'All rights reserved'
description      'Installs/Configures emulab-nfs'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

# More on cookbook dependecies: https://docs.chef.io/config_rb_metadata.html 
# More specific requirements are expressed in individual recipes (see include_recipe directives). 
depends 'nfs'
