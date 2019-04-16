# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure('2') do |config|
  config.vm.provider 'virtualbox' do |vb|
    vb.name = 'consul-builder'
    vb.linked_clone = true
    vb.memory = 512
    vb.cpus = 2
    vb.customize ['modifyvm', :id, '--ioapic', 'on']
  end

  config.vm.define 'consul-builder'
  config.vm.box = 'bento/centos-7'
  config.vm.hostname = 'consul-builder'
  config.vm.network :private_network, type: 'dhcp'

  config.vm.provision 'shell', inline: 'yum install -y rpmdevtools'
  config.vm.provision 'shell', path: 'build.sh', env: {
    'SOURCE' => '/vagrant',
    'ARTIFACTS' => '/vagrant/artifacts',
    'BUILDDIR' => '/tmp/rpmbuild'
  }
end
