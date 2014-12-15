version = "1.4.6"

#remote_file will fetch the file only if it's not here already
remote_file "fetch_nginx_source" do
  source "http://nginx.org/download/nginx-#{version}.tar.gz"
  path "#{Chef:Config['file_cache_path']}/nginx-#{version}.tar.gz"
end


bash "Install NGINX from source" do
  cwd Chef::Config['file_cache_path']
  code <<-EOH
    tar zxf nginx-#{version}.tar.gz &&
    cd nginx-#{version} &&
    ./configure --without-http_rewrite_module    --without-http_gzip_module && make && make install
  EOH
  not_if "test -f /usr/local/nginx/sbin/nginx"
end
