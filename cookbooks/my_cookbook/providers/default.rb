action :create do
  log "Adding '#{new_resource.name}'greeting as #{new_resource.path}"
  file new_resource.path do
    content "#{new_resource.name}, #{new_resource.title}!"
    action :create
  end
end

action :remove do

  log "removing '#{new_resource.name}'greeting #{new_resource.path}"

  file new_resource.name do
    action :delete
  end
end
