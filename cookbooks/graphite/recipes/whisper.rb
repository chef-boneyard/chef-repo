remote_file "/usr/src/whisper-#{node.graphite.whisper.version}.tar.gz" do
  source node.graphite.whisper.uri
  checksum node.graphite.whisper.checksum
end

execute "untar whisper" do
  command "tar xzf whisper-#{node.graphite.whisper.version}.tar.gz"
  creates "/usr/src/whisper-#{node.graphite.whisper.version}"
  cwd "/usr/src"
end

execute "install whisper" do
  command "python setup.py install"
  creates "/usr/local/lib/python2.6/dist-packages/whisper-#{node.graphite.whisper.version}.egg-info"
  cwd "/usr/src/whisper-#{node.graphite.whisper.version}"
end
