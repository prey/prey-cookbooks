gems = node["ruby"]["gems"]

gems.each do |g|
    log "installing gem #{node["ruby"]["gems"]}"
    execute "gem install" do
	cwd "/home/#{node["user"]}"
	command "su #{node["user"]} -c '~/.rbenv/shims/gem install #{g}'"
	not_if "~/.rbenv/shims/gem list |grep " + g
	action :run
    end
end
