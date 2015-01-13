class Chef
  class Resource
    class ElasticsearchService < Chef::Resource
      def initialize(name, run_context = nil)
        super
        @allowed_actions = [:create, :delete]
        @action          = :create
        @provider        = Chef::Provider::ElasticsearchService
        @resource_name   = :elasticsearch_service
      end

      def directory(arg = nil)
        set_or_return(
          :directory,
          arg,
          kind_of: String
        )
      end

      def type(arg = nil)
        set_or_return(
          :type,
          arg,
          kind_of: String
        )
      end

      def version(arg = nil)
        set_or_return(
          :version,
          arg,
          kind_of: String
        )
      end
    end
  end
end


