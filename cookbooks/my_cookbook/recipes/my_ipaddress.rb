chef_gem 'ipaddress'
 require 'ipaddress'
 ip = "192.168.0.1/24"
 mask = IPAddress.netmask(ip) 
 Chef::Log.info("RECEPIE [#{recipe_name}] COOKBOOK [#{cookbook_name}] : Netmask of #{ip}: [#{mask}]")
