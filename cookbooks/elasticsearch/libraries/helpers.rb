module Opscode
  module Elasticsearch
    module Helpers
      # Directory containing ES installation.
      # @return [String] Installation directory
      def installer_path
        ::File.basename(installer_url)
      end

      # URL of binary installation archive.
      # @return [String] Installer source address
      def installer_url
        "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-#{new_resource.version}.tar.gz"
      end

      # Directories leveraged, determined  by platform and install method.
      # @return [Hash] Hash of directories
      def directories
        if new_resource.type == 'source'
          value_for_platform_family(
            rhel: {
              install: '/opt/elasticsearch',
              config:  '/etc/elasticsearch',
              data:    '/var/lib/elasticsearch',
              pid:     '/var/run/elasticsearch',
              plugin:  '/opt/elasticsearch/plugins',
              work:    '/tmp/elasticsearch'
            },
            smartos: {
              install: '/opt/local/elasticsearch',
              class:   '/opt/local/elasticsearch/lib',
              config:  '/opt/local/elasticsearch/config',
              data:    '/var/db/elasticsearch',
              pid:     '/var/tmp/elasticsearch',
              plugin:  '/opt/local/elasticsearch/plugins',
              work:    '/var/tmp/elasticsearch'
            }
          )
        else
          value_for_platform_family(
            rhel: {
              install: '/usr/share/elasticsearch',
              config:  '/etc/elasticsearch',
              data:    '/var/lib/elasticsearch',
              pid:     '/var/run/elasticsearch',
              plugin:  '/usr/share/elasticsearch/plugins',
              work:    '/tmp/elasticsearch'
            },
            smartos: {
              install: '/opt/local/lib/elasticsearch',
              class:   '/opt/local/lib/elasticsearch',
              config:  '/opt/local/etc/elasticsearch',
              data:    '/var/db/elasticsearch',
              pid:     '/var/tmp/elasticsearch',
              plugin:  '/opt/local/lib/elasticsearch/plugins',
              work:    '/var/tmp/elasticsearch'
            }
          )
        end
      end
    end
  end
end
