package "qemu-kvm"
package "libvirt-bin"
package "ubuntu-vm-builder"
package "bridge-utils"
package "opennebula"

ruby_block "save public key" do
  block do
    begin
      data_bag_item( "oneadmin", "public_key" )
    rescue Net::HTTPServerException
      public_key = File.open( "/var/lib/one/.ssh/id_rsa.pub", "rb" )
      item = Chef::DataBagItem.new
      item.data_bag "oneadmin"
      item.raw_data = { "id" => "public_key", "content" => public_key.read }
      item.save
      Chef::Log.info "Uploaded oneadmin public key"
    end
  end
  action :create
end

template "/var/lib/one/.ssh/config" do
  source "ssh_config.erb"
  owner "oneadmin"
  group "cloud"
  mode "644"
  not_if do
    File.exists?("/var/lib/one/.ssh/config")
  end
end

execute "adding public key to authorized_keys" do
  command "sudo -u oneadmin cat /var/lib/one/.ssh/id_rsa.pub > /var/lib/one/.ssh/authorized_keys"
  not_if "sudo -u oneadmin grep oneadmin /var/lib/one/.ssh/authorized_keys"
end

template "/var/lib/one/.one/one_auth" do
  source "one_auth.erb"
  owner "oneadmin"
  group "cloud"
  mode "644"
  variables :password => "oneadmin"
  not_if "grep oneadmin:oneadmin /var/lib/one/.one/one_auth"
end

group "libvirtd" do
  gid 119
  members ['oneadmin']
end

group "kvm" do
  gid 118
  members ['oneadmin']
end

service "opennebula" do
  pattern "oned"
  supports :restart => true, :reload => true
  action [ :enable, :start ]
end

execute "adding ONEHOST entry for #{node.fqdn}" do
  command "sudo -u oneadmin onehost create #{node.fqdn} im_kvm vmm_kvm tm_ssh"
  not_if "sudo -u oneadmin onehost list | grep #{node.fqdn}"
end

search(:node, 'role:opennebula-node').each do |server|
  execute "adding ONEHOST entry for #{server.fqdn}" do
    command "sudo -u oneadmin onehost create #{server.fqdn} im_kvm vmm_kvm tm_ssh"
    not_if "sudo -u oneadmin onehost list | grep #{server.fqdn}"
  end
end

directory "/var/lib/one/templates" do
  owner "oneadmin"
  group "cloud"
  mode "0755"
  action :create
end

remote_file "/var/lib/one/images/#{node.opennebula.admin.osimage}.qcow2" do
  source node.opennebula.admin.uri
  owner "oneadmin"
  mode "0644"
  checksum node.opennebula.admin.checksum
  not_if do
    File.exists?("/var/lib/one/images/#{node.opennebula.admin.osimage}.qcow2")
  end
end

template "/var/lib/one/templates/#{node.opennebula.admin.osimage}.template" do
  source "#{node.opennebula.admin.osimage}.erb"
  owner "oneadmin"
  group "cloud"
  mode "644"
  not_if do
    File.exists?("/var/lib/one/templates/#{node.opennebula.admin.osimage}.template")
  end
end

execute "registering ONEIMAGE osimage #{node.opennebula.admin.osimage}" do
  command "sudo -u oneadmin oneimage create /var/lib/one/templates/#{node.opennebula.admin.osimage}.template"
  not_if "sudo -u oneadmin oneimage list | grep 10.04"
end

template "/var/lib/one/templates/#{node.opennebula.admin.onevnet}.template" do
  source "#{node.opennebula.admin.onevnet}.erb"
  owner "oneadmin"
  group "cloud"
  mode "644"
  not_if do
    File.exists?("/var/lib/one/templates/#{node.opennebula.admin.onevnet}.template")
  end
end

execute "registering ONEVNET #{node.opennebula.admin.onevnet} to opennebula" do
  command "sudo -u oneadmin onevnet create /var/lib/one/templates/#{node.opennebula.admin.onevnet}.template"
  not_if "sudo -u oneadmin onevnet list | grep #{node.opennebula.admin.onevnet}"
end

template "/var/lib/one/templates/machine01.template" do
  source "machine01.erb"
  owner "oneadmin"
  group "cloud"
  mode "644"
  not_if do
    File.exists?("/var/lib/one/templates/machine01.template")
  end
end
