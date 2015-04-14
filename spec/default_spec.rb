require_relative 'spec_helper'

describe 'elasticsearch_lwrp::default' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(step_into: ['elasticsearch']) do |node|
      node.set[:elasticsearch][:interface] = 'eth0'
    end.converge(described_recipe)
  end

  let(:elastic) { chef_run.node.elasticsearch }

  context 'SmartOS' do
    it 'will install java' do
      expect(chef_run).to install_package('openjdk7')
    end

    it 'will provision group' do
      expect(chef_run).to create_group('elasticsearch').with({
        gid: elastic[:group][:gid]
      })
    end

    it 'will provision user' do
      expect(chef_run).to create_user(elastic[:user][:name]).with({
        gid:     elastic[:group][:name],
        group:   elastic[:group][:name],
        shell:   '/usr/bin/false',
        uid:     elastic[:user][:uid]
      })
    end

    it 'will create installation directories' do
      [
       elastic[:dir][:data],
       elastic[:dir][:home],
       elastic[:dir][:log],
       elastic[:dir][:plugin],
       elastic[:dir][:work]
      ].each do |dir|
        expect(chef_run).to create_directory(dir).with({
          owner: elastic[:user][:name],
          group: elastic[:group][:name],
          mode:  '0775'
        })
      end
    end

    it 'will create configuration directory' do
      expect(chef_run).to create_directory(
        ::File.dirname(elastic[:file][:config])
    )
    end

    it 'will create config file' do
      expect(chef_run).to render_file(elastic[:file][:config])
    end

    it 'will provision PID file directory' do
      expect(chef_run).to create_directory(File.dirname(elastic[:file][:pid]))
    end
  end

  context 'Marvel' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(step_into: ['elasticsearch']) do |node|
        node.set[:elasticsearch][:cluster]   = 'testing'
        node.set[:elasticsearch][:interface] = 'eth0'
        node.set[:elasticsearch][:type]      = 'marvel'
      end.converge(described_recipe)
    end

    it 'will have expected type' do
      expect(chef_run.node[:elasticsearch][:type]).to eq 'marvel'
    end

    it 'will have a _marvel cluster name suffix' do
      expect(chef_run).to render_file('/opt/local/elasticsearch/config/elasticsearch.yml').with_content(/testing_marvel/)
    end
  end
end
