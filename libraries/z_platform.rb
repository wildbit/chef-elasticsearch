require_relative 'resource_elasticsearch'
require_relative 'provider_elasticsearch'
require_relative 'provider_elasticsearch_rhel'
require_relative 'provider_elasticsearch_smartos'

Chef::Platform.set platform: :amazon,     resource: :elasticsearch, provider: Chef::Provider::Elasticsearch::Rhel
Chef::Platform.set platform: :centos,     resource: :elasticsearch, provider: Chef::Provider::Elasticsearch::Rhel
Chef::Platform.set platform: :redhat,     resource: :elasticsearch, provider: Chef::Provider::Elasticsearch::Rhel
Chef::Platform.set platform: :scientific, resource: :elasticsearch, provider: Chef::Provider::Elasticsearch::Rhel
Chef::Platform.set platform: :smartos,    resource: :elasticsearch, provider: Chef::Provider::Elasticsearch::Smartos
