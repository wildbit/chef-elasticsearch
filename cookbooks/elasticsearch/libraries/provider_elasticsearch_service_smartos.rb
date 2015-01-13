require 'chef/provider/lwrp'

class Chef
  class Provider
    class ElasticsearchService < Chef::Provider::LWRPBase
      use_inline_resources

      def whyrun_supported?
        true
      end

      action :create do
        package 'elasticsearch'
      end
    end
  end
end
