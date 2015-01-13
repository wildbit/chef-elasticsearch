require_relative 'helpers'

class Chef
  class Provider
    class ElasticsearchService < Chef::Provider::LWRPBase
      include Opscode::Elasticsearch::Helpers

      use_inline_resources

      def whyrun_supported?
        true
      end
      
      action :create do
        remote_file installer_url do
          owner  'root'
          group  'root'
          mode   '0755'
          path   installer_path
          backup false
        end

        directory 
      end

      action :delete do
      end
    end
  end
end
