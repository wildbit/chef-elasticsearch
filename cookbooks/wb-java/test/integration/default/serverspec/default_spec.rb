require 'serverspec'

include Serverspec::Helper::DetectOS
include Serverspec::Helper::Exec

describe 'wb-java::default' do

  describe file('/usr/bin/java') do
    it { should be_linked_to '/etc/alternatives/java' }
  end

  describe file('/etc/alternatives/java') do
    it { should be_linked_to '/usr/lib/jvm/java/bin/java' }
  end

  describe file('/usr/lib/jvm/java/bin/java') do
    it { should be_file }
  end
end
