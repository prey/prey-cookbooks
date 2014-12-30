bash "install-golang" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    rm -rf go
    rm -rf #{node['install_dir']}/go
    tar -C #{node['install_dir']} -zxf #{node['filename']}
  EOH
  action :nothing
end

remote_file File.join(Chef::Config[:file_cache_path], node['filename']) do
  source node['url']
  owner 'root'
  mode 0644
  notifies :run, 'bash[install-golang]', :immediately
  not_if "#{node['install_dir']}/go/bin/go version | grep \"go#{node['version']} \""
end

directory node['gopath'] do
  action :create
  recursive true
  owner node['owner']
  group node['group']
  mode 0755
end

directory node['gobin'] do
  action :create
  recursive true
  owner node['owner']
  group node['group']
  mode 0755
end

template "/etc/profile.d/golang.sh" do
  source "golang.sh.erb"
  owner 'root'
  group 'root'
  mode 0755
end

