package "qemu-kvm"
package "libvirt-bin"
package "ubuntu-vm-builder"
package "bridge-utils"
package "opennebula-common"
package "opennebula-node"

#custom upgrade to 2.2 requires packages built from OpenNebula 2.2
#source. comment out if you do not wish to customize upgrade.

directory "/tmp/upgrade" do
  owner "oneadmin"
  group "cloud"
  mode "0755"
  action :create
end

remote_file "/tmp/upgrade/#{node.opennebula.dpkg.dpkg_opennebula_common}" do
  source node.opennebula.dpkg.uri_opennebula_common
  owner "oneadmin"
  mode "0644"
  not_if do
    File.exists?("/tmp/upgrade/#{node.opennebula.dpkg.dpkg_opennebula_common}")
  end
end

remote_file "/tmp/upgrade/#{node.opennebula.dpkg.dpkg_opennebula_node}" do
  source node.opennebula.dpkg.uri_opennebula_node
  owner "oneadmin"
  mode "0644"
  not_if do
    File.exists?("/tmp/upgrade/#{node.opennebula.dpkg.dpkg_opennebula_node}")
  end
end

execute "performing OpenNebula UPGRADE to 2.2" do
  command "sudo dpkg -i /tmp/upgrade/#{node.opennebula.dpkg.dpkg_opennebula_common} /tmp/upgrade/#{node.opennebula.dpkg.dpkg_opennebula_node}"
  not_if "dpkg -l | grep opennebula | grep ii | grep 2.2"
end

#end custom upgrade

template "/var/lib/one/.ssh/config" do
  source "ssh_config.erb"
  owner "oneadmin"
  group "cloud"
  mode "644"
  not_if do
    File.exists?("/var/lib/one/.ssh/config")
  end
end

file "/var/lib/one/.ssh/authorized_keys" do
  content data_bag_item( "oneadmin", "public_key" )["content"]
  owner "oneadmin"
  mode "600"
  not_if do
    File.exists?("/var/lib/one/.ssh/authorized_keys")
  end
end

execute "adding public key to authorized_keys" do
  command "sudo -u oneadmin cat /var/lib/one/.ssh/id_rsa.pub >> /var/lib/one/.ssh/authorized_keys"
  not_if "sudo -u oneadmin grep #{node.fqdn} /var/lib/one/.ssh/authorized_keys"
end

group "libvirtd" do
  group_name "libvirtd"
  append true
  members ['oneadmin']
end

group "kvm" do
  group_name "kvm"
  append true
  members ['oneadmin']
end
