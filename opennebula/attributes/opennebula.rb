::Chef::Node.send(:include, Opscode::OpenSSL::Password)

set_unless[:opennebula][:password] = secure_password
default[:opennebula][:clustername] = "default"
default[:opennebula][:admin][:uri] = "http://example.com/your_ubuntu_10.04.1-server-image.qcow2"
default[:opennebula][:admin][:checksum] ="5ca1ab1e"
default[:opennebula][:admin][:osimage] = "ubuntu-10.04.1-server"
default[:opennebula][:admin][:onevnet] = "vnet01"
