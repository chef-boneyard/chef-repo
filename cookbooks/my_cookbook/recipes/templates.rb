#templates and node environments
template '/tmp/message' do
  source 'message.erb'
  variables(
    greet: 'Hallo',
    who: 'me',
    from: node['fqdn']
   )
end

template '/tmp/fqdn' do
  source 'fqdn.erb'
  variables(
  fqdn: node['fqdn']
  )
end


#Added an ERB template:

template "/etc/logrotate.conf" do
  source "logrotate.conf.erb"
  variables(
    how_often: "daily",
    keep: 31
  )
end

template "/etc/backends.conf" do
  mode "0444"
  owner "root"
  group "root"
  variables({
    :enabled => true,
    :backends => ["10.0.0.10", "10.0.0.11", "10.0.0.12"]
  })
  source "backends.conf.erb"
end
