::Chef::Node.send(:include, Opscode::OpenSSL::Password)

set_unless[:opennebula][:password] = secure_password
default[:opennebula][:clustername] = "default"
default[:opennebula][:admin][:uri] = "https://exampledomain.com/your_ubuntu_10.04.1-server-image.qcow2"
default[:opennebula][:admin][:checksum] ="5ca1ab1e"
default[:opennebula][:admin][:osimage] = "ubuntu-10.04.1-server"
default[:opennebula][:admin][:onevnet] = "Public"
default[:opennebula][:dpkg][:uri_opennebula] = "https://exampledomain.com/opennebula_2.2-1_amd64.deb"
default[:opennebula][:dpkg][:uri_opennebula_common] = "https://exampledomain.com/opennebula-common_2.2-1_all.deb"
default[:opennebula][:dpkg][:uri_libopennebula_java] = "https://exampledomain.com/libopennebula-java_2.2-1_all.deb"
default[:opennebula][:dpkg][:uri_opennebula_node] = "https://exampledomain.com/opennebula-node_2.2-1_all.deb"
default[:opennebula][:dpkg][:dpkg_opennebula] = "opennebula_2.2-1_amd64.deb"
default[:opennebula][:dpkg][:dpkg_opennebula_common] = "opennebula-common_2.2-1_all.deb"
default[:opennebula][:dpkg][:dpkg_libopennebula_java] = "libopennebula-java_2.2-1_all.deb"
default[:opennebula][:dpkg][:dpkg_opennebula_node] = "opennebula-node_2.2-1_all.deb"
