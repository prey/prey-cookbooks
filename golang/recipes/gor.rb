git "/usr/local/src/gor" do
  repository "https://github.com/buger/gor.git"
  revision "master"
  action :checkout
  user "root"
  not_if { File.exist?("/usr/local/bin/gor") }
end

execute "go build gor.go" do
  cwd "/usr/local/src/gor"
  user "root"
  command <<-EOH
    GOPATH=/opt/go /usr/local/go/bin/go get github.com/buger/elastigo/api
    GOPATH=/opt/go /usr/local/go/bin/go get github.com/buger/gor/raw_socket_listener
    GOPATH=/opt/go /usr/local/go/bin/go build
    cp /usr/local/src/gor/gor /usr/local/bin
  EOH
  not_if { File.exist?("/usr/local/bin/gor") }
end

