action :delete do
  file "/etc/cron.d/#{new_resource.name}" do
    action :delete
  end
end

action :create do
  t = template "/etc/cron.d/#{new_resource.name}" do
    cookbook new_resource.cookbook
    source "cron.d.erb"
    mode "0644"
    variables({
        :name => new_resource.name,

        :minute => new_resource.minute,
        :hour => new_resource.hour,
        :day => new_resource.day,
        :month => new_resource.month,
        :weekday => new_resource.weekday,

        :command => new_resource.command,
        :user => new_resource.user,

        :mailto => new_resource.mailto,
        :path => new_resource.path,
        :home => new_resource.home,
        :shell => new_resource.shell
      })
    action :create
  end
  new_resource.updated_by_last_action(t.updated_by_last_action?)
end
