package "git"
package "libffi-dev"

node.override["user"] = ["_default", "development"].include?(node.chef_environment) ? "vagrant" : "deploy"

log "cloning rbenv... #{node.chef_environment} - #{node["user"]}"
git "/home/#{node['user']}/.rbenv" do
  repository "https://github.com/sstephenson/rbenv.git"
  revision "master"
  action :checkout
  user "#{node['user']}"
end

log "cloning ruby-build"

directory "/home/#{node["user"]}/.rbenv/plugins" do
  owner "#{node["user"]}"
  group "#{node["user"]}"
  mode 00755
  action :create
end

git "/home/#{node["user"]}/.rbenv/plugins/ruby-build" do
  repository "https://github.com/sstephenson/ruby-build.git"
  revision "master"
  action :sync
  user "#{node["user"]}"
end

log "adding rbenv variables"
bash "rbenv .bashrc variables" do
  user "#{node["user"]}"
  cwd "/tmp"
  code <<-EOT
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/#{node["user"]}/.bash_profile
    echo 'eval "$(rbenv init -)"' >> /home/#{node["user"]}/.bash_profile
  EOT
end

versions = node["ruby"]["version"]

versions.each do |ver|
   log "installing ruby #{node["ruby"]["version"]}"
   execute "rbenv install" do
     cwd "/home/#{node["user"]}"
     command "su #{node["user"]} -c 'CONFIGURE_OPTS=#{node["options"]} /home/#{node["user"]}/.rbenv/bin/rbenv install " + ver + "'"
     action :run
     not_if { File.exist?("/home/#{node["user"]}/.rbenv/versions/" + ver)}
   end
end

log "set ruby version"
execute "rbenv local" do
   cwd "/home/#{node["user"]}"
   command "su #{node["user"]} -c '/home/#{node["user"]}/.rbenv/bin/rbenv local " + versions.first + "'"
   action :run
end
