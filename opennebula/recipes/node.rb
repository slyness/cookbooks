package "qemu-kvm"
package "libvirt-bin"
package "ubuntu-vm-builder"
package "bridge-utils"
package "opennebula-common"
package "opennebula-node"

file "/var/lib/one/.ssh/authorized_keys" do
  content data_bag_item( "oneadmin", "public_key" )["content"]
  owner "oneadmin"
  mode "600"
end

execute "adding public key to authorized_keys" do
  command "sudo -u oneadmin cat /var/lib/one/.ssh/id_rsa.pub >> /var/lib/one/.ssh/authorized_keys"
  not_if "sudo -u oneadmin grep #{node.fqdn} /var/lib/one/.ssh/authorized_keys"
end

group "libvirtd" do
  gid 119
  members ['oneadmin']
end

group "kvm" do
  gid 118
  members ['oneadmin']
end



