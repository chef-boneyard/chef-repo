version = "1.4.6"

bash "Install NGINX from source" do
  cwd Chef::Config['file_cache_path']
  code <<-EOH
    wget http://nginx.org/download/nginx-#{version}.tar.gz
    tar zxf nginx-#{version}.tar.gz &&
    cd nginx-#{version} &&
    ./configure && make && make install
  EOH
  not_if "test -f /usr/local/nginx/sbin/nginx"
end
