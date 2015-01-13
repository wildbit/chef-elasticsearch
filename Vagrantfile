Vagrant.configure('2') do |config|
  config.omnibus.chef_version = :latest
  config.vm.box               = 'opscode-centos-6.6'
  config.vm.box_url           = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.6_chef-provisionerless.box'
  config.vm.hostname          = 'elasticsearch.dev'
  config.vm.network           :private_network, type: :dhcp

  config.vm.provision :chef_zero do |chef|
    chef.add_recipe 'wb-java'
    chef.add_recipe 'elasticsearch'

    chef.json = { 
      elasticsearch: {
        type: 'all'
      }
    }
  end
end
