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
    how_often: "weekly",
    keep: 31
  )
end
