::Chef::Node.send(:include, Opscode::OpenSSL::Password)

set_unless[:opennebula][:password] = secure_password
default[:opennebula][:clustername] = "default"
default[:opennebula][:admin][:uri] = "https://exampledomain.com/your_ubuntu_10.04.1-server-image.qcow2"
default[:opennebula][:admin][:checksum] ="5ca1ab1e"
default[:opennebula][:admin][:osimage] = "ubuntu-10.04.1-server"
default[:opennebula][:admin][:onevnet] = "Public"
default[:opennebula][:dpkg][:uri_1] = "https://exampledomain.com/opennebula_2.2-1_amd64.deb"
default[:opennebula][:dpkg][:uri_2] = "https://exampledomain.com/opennebula-common_2.2-1_all.deb"
default[:opennebula][:dpkg][:uri_3] = "https://exampledomain.com/libopennebula-java_2.2-1_all.deb"
default[:opennebula][:dpkg][:uri_4] = "https://exampledomain.com/opennebula-node_2.2-1_all.deb"
default[:opennebula][:dpkg][:dpkg_1] = "opennebula_2.2-1_amd64.deb"
default[:opennebula][:dpkg][:dpkg_2] = "opennebula-common_2.2-1_all.deb"
default[:opennebula][:dpkg][:dpkg_3] = "libopennebula-java_2.2-1_all.deb"
default[:opennebula][:dpkg][:dpkg_4] = "opennebula-node_2.2-1_all.deb"
