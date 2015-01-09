#roles search, getting the info from roles
logservers = search(:node, "role:log" )

logservers.each do |srv|
  log srv.name
end


template "/tmp/list_of_logservers" do
  source "list_of_logservers.erb"
  variables(
    :logservers => logservers
  )
end
