gems = node["ruby"]["gems"]

gems.each do |g|
    log "installing gem " + g
    execute "gem install " + g do
	cwd "/home/#{node["user"]}"
	command "su #{node["user"]} -c '~/.rbenv/shims/gem install #{g}'"
	not_if "su - deploy -c '~/.rbenv/shims/gem list |grep " + g + "'"
	action :run
    end
end
