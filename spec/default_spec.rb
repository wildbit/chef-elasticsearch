require_relative 'spec_helper'

describe 'elasticsearch_lwrp::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }
 
  it 'will install elasticsearch' do
    expect(chef_run).to create_elasticsearch('1.4.2')
  end
end
