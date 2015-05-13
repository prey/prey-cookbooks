execute "aptitude update" do
   command "aptitude update"
   ignore_failure true
   action :run
end

Chef::Log.info "packages:#{node['packages']}"
node['packages'].each do |pkg|
  puts "installing: " + pkg
  package pkg
end
