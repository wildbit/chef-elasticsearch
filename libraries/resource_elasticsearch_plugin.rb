require 'chef/resource'

class Chef
  class Resource
    class ElasticsearchPlugin < Chef::Resource
      attr_accessor :installed
      
      def initialize(name, run_context = nil)
        super
        @action          = :install
        @allowed_actions = [:install, :remove]
        @resource_name   = :elasticsearch_plugin
        @provider        = Chef::Provider::ElasticsearchPlugin
      end

      def plugin_binary(arg = nil)
        set_or_return(
          :plugin_binary,
          arg,
          default: '/opt/local/elasticsearch/bin/plugin',
          kind_of: String
        )
      end

      def plugin_name(arg = nil)
        set_or_return(
          :plugin_name,
          arg,
          kind_of:        String,
          name_attribute: true
        )
      end

      def plugin_version(arg = nil)
        set_or_return(
          :plugin_version,
          arg,
          default: nil,
          kind_of: [Fixnum, NilClass, String]
        )
      end
    end
  end
end
