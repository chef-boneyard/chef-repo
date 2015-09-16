#
# Cookbook Name:: emulab-shiny
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "emulab-R"

bash 'Install R shiny package' do
  code <<-EOH
    R -e "install.packages('shiny', repos='https://cran.rstudio.com/')"
  EOH
end

apt_package 'gdebi-core' do
  action :install
end

remote_file '/tmp/shiny-server-1.4.0.721-amd64.deb' do
  source 'https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.4.0.721-amd64.deb'
  checksum 'bd8bf2422e63c97cc23ee6a412634b4eed5814d1342f9001f10fabea5e411558'
end

bash 'Install Shiny' do
  code <<-EOH
    echo "y\n" | gdebi /tmp/shiny-server-1.4.0.721-amd64.deb
  EOH
  not_if "status shiny-server | grep running"
end

# Delete the default app
directory '/srv/shiny-server' do
  recursive true
  action :delete
end

# Clone the repo specified in the attributes file
git '/srv/shiny-server' do
  repository node['shiny']['shiny-server-repo'] 
  revision 'master'
  action :checkout
end
