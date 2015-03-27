require_relative 'spec_helper'

describe 'elasticsearch_lwrp::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }
  let(:node)     { chef_run.node }

  it 'will install elasticsearch' do
    expect(chef_run).to install_elasticsearch(node.elasticsearch.version)
  end
end
