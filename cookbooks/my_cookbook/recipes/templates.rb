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