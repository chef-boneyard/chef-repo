#
# Cookbook Name:: emulab-R
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Do: apt-get update
include_recipe 'apt'

apt_package 'software-properties-common' do
  action :install
end

bash 'Add CRAN repo' do
  code <<-EOH
    echo "deb http://ftp.ussg.iu.edu/CRAN/bin/linux/ubuntu `lsb_release -c -s`/" | sudo tee -a /etc/apt/sources.list > /dev/null
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
  EOH
  not_if "R --version | grep 3.2.2"
end

# Do: apt-get update
include_recipe 'apt'

apt_package 'r-base' do
  action :install
end

bash 'Install ggplot2, which is a useful plotting tool' do
  code <<-EOH
    R -e "install.packages('ggplot2', repos='https://cran.rstudio.com/')"
  EOH
end
