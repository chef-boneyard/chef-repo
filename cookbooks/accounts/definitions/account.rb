#
# Cookbook Name: accounts
# Definition: account
#
# Copyright 2009, Alexander van Zoest
#
#define :account, :uid => nil,  :comment => nil, :group => node[:accounts][:default][:group], :ssh => node[:accounts][:default][:do_ssh], :sudo => node[:accounts][:default][:do_sudo] do
define :account, :account_type => "user", :uid => nil,  :comment => nil, :group => "users", :ssh => true, :sudo => false do
#    group params[:group] do
#      gid params[:gid]
#    end

  user params[:name] do
    comment params[:comment] if params[:comment]
    password params[:password].crypt(params[:password]) if params[:password]
    uid params[:uid] if params[:uid]
    gid params[:gid] || params[:group]
    shell params[:shell] || node[:accounts][:default][:shell]
    home "#{node[:accounts][:dir]}/#{params[:name]}"
    action :create
  end

  directory "#{node[:accounts][:dir]}/#{params[:name]}" do
    recursive true
    owner params[:name]
    group params[:gid] || params[:group]
    mode 0700
  end

  if params[:ssh]
    remote_directory "#{node[:accounts][:dir]}/#{params[:name]}/.ssh" do
      cookbook node[:accounts][:cookbook]
      source "#{params[:account_type]}s/#{params[:name]}/ssh"
      files_backup node[:accounts][:default][:file_backup]
      files_owner params[:name]
      files_group params[:gid] || params[:group]
      files_mode 0600
      owner params[:name]
      group params[:gid] || params[:group]
      mode "0700"
    end
  end

  if params[:sudo]
    unless node[:accounts].has_key?(:sudo)
      node[:accounts][:sudo] = Mash.new
    end
    unless node[:accounts][:sudo].has_key?(:groups)
       node[:accounts][:sudo][:groups] = Array.new
    end
    unless node[:accounts][:sudo].has_key?(:users)
       node[:accounts][:sudo][:users] = Array.new 
    end
    unless node[:accounts][:sudo][:groups].include?(params[:group])
        node[:accounts][:sudo][:users] |= [params[:name]]
    end
  end

end
