
http_request 'callback' do
 url node['my_cookbook']['callback']['url']
 only_if { node['my_cookbook']['callback']['enabled'] }
end
