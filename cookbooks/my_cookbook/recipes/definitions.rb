#Definitions.
# Added to definitions/capistrano_deploy_dirs.rb:

#define :capistrano_deploy_dirs, :deploy_to => '' do
#  directory "#{params[:deploy_to]}/releases"
#  directory "#{params[:deploy_to]}/shared"
#  directory "#{params[:deploy_to]}/shared/system"
#end


capistrano_deploy_dirs do
  deploy_to "/srv"
end
