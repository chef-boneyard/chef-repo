passwords = EncryptedPasswords.new(node, node["percona"]["encrypted_data_bag"])

# define access grants
template "/etc/mysql/grants.sql" do
  source "grants.sql.erb"
  variables(
    :root_password        => passwords.root_password,
    :debian_user          => node["percona"]["server"]["debian_username"],
    :debian_password      => passwords.debian_password,
    :backup_password      => passwords.backup_password
  )
  owner "root"
  group "root"
  mode "0600"
end

# execute access grants
if passwords.root_password && !passwords.root_password.empty?
  # Intent is to check whether the root_password works, and use it to 
  # load the grants if so.  If not, try loading without a password 
  # and see if we get lucky
  execute "mysql-install-privileges" do
    command "/usr/bin/mysql -p'" + passwords.root_password + "' -e '' &> /dev/null > /dev/null &> /dev/null ; if [ $? -eq 0 ] ; then /usr/bin/mysql -p'" + passwords.root_password + "' < /etc/mysql/grants.sql ; else /usr/bin/mysql < /etc/mysql/grants.sql ; fi ;"
    action :nothing
    subscribes :run, resources("template[/etc/mysql/grants.sql]"), :immediately
  end
else
  # Simpler path...  just try running the grants command
  execute "mysql-install-privileges" do
    command "/usr/bin/mysql < /etc/mysql/grants.sql"
    action :nothing
    subscribes :run, resources("template[/etc/mysql/grants.sql]"), :immediately
  end
end
  
