# -*- mode: ruby -*-
# vi: set ft=ruby :
domain = 'xebialabs.demo'

nodes = [
  { :hostname => 'dbqa', :ip => '10.0.0.204', :box => 'spantree/ubuntu-precise-64', :ram => 512 },
  { :hostname => 'dbprod', :ip => '10.0.0.205', :box => 'spantree/ubuntu-precise-64', :ram => 512 },

  { :hostname => 'tomcat1', :ip => '10.0.0.101', :box => 'spantree/ubuntu-precise-64', :ram => 1024},
  { :hostname => 'tomcat2', :ip => '10.0.0.102', :box => 'spantree/ubuntu-precise-64', :ram => 1024 },
  { :hostname => 'tomcat3', :ip => '10.0.0.103', :box => 'spantree/ubuntu-precise-64', :ram => 1024 },
]

# http://superuser.com/questions/144453/virtualbox-guest-os-accessing-local-server-on-host-os wget http://10.0.2.2:4516
Vagrant.configure("2") do |config|
  nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|

      #node_config.vbguest.auto_update = false

      node_config.vm.box = node[:box]
      node_config.vm.host_name = node[:hostname] + '.' + domain
      node_config.vm.network :private_network, ip: node[:ip]
      node_config.vm.synced_folder ENV["CATALOG"], "/catalog", mount_options: ['dmode=777','fmode=666' ]

      memory = node[:ram] ? node[:ram] : 256;
      node_config.vm "virtualbox" do |v|
        v.customize[ 'modifyvm', :id, '--name', node[:hostname], '--memory', memory.to_s ]
      end
    end
  end

  config.vm.provision :shell, :path => "scripts/ansible.sh"

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provisioning/playbook.yml"
    #ansible.inventory_path = "provisioning/hosts-vagrant"
    ansible.verbose = 'v' # 'v','vv','vvv','vvvv'
    ansible.groups = {
      "web" => ["tomcat1","tomcat2","tomcat3"],
      "db" => ["dbqa","dbprod"],
    }
  end
end
