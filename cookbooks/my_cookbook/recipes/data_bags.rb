#some work with data bags. info is in data data_bags dir JSON files.
#For example:

#data_bags/accounts/google.json 
#{
#  "id": "google",
#  "email": "some.one@gmail.com",
#  "password": "123456"
#}



#hook = data_bag_item('hooks', 'request_bin')
#http_request 'callback' do
#  url hook['url']
#end

#same as above, but more elaborate
search(:hooks, '*:*').each do |hook|
  http_request 'callback' do
    url hook['url']
  end
end

google_account = Chef::EncryptedDataBagItem.load("accounts", "google")


#TEST:

Chef::Log.info ("TEST --->   encrypted password is:#{google_account["password"]}    <---TEST")


#hook = data_bag_item('hooks', 'request_bin')
#http_request 'callback' do
#  url hook['url']
#end

#same as above, but more elaborate
search(:hooks, '*:*').each do |hook|
  http_request 'callback' do
    url hook['url']
  end
end

google_account = Chef::EncryptedDataBagItem.load("accounts", "google")


#TEST:

Chef::Log.info ("TEST --->   encrypted password is:#{google_account["password"]}    <---TEST")


#Get the data from the JSON data bag and put it in a file
file "/tmp/backup_config.json" do
  owner "root"
  group "root"
  mode 0644
  content data_bag_item('servers', 'backup')['host'].to_json
end