Vagrant.configure('2') do |config|
  VM_NAME = 'alpha-test'.freeze

  config.vm.box       = 'ubuntu/trusty64'
  config.vm.hostname  = VM_NAME

  config.vm.network 'private_network', type: 'dhcp'
  config.vm.network :forwarded_port, guest: 3000, host: 3000, auto_correct: true

  config.ssh.forward_agent = true

  config.vm.synced_folder '.', '/vagrant', type: 'nfs'

  config.vm.provider :virtualbox do |vb, _override|
    vb.name   = VM_NAME
    vb.memory = 1024
    vb.cpus   = 2
  end

  # diable vbguest autoupdate because of annoying warnings
  config.vbguest.auto_update = false if Vagrant.has_plugin?('vagrant-vbguest')

  config.vm.provision 'ansible_local' do |ansible|
    ansible.playbook = 'provision/playbook.yml'
  end
end
