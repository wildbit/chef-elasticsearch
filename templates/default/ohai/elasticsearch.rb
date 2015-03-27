require 'json'
require 'mime/types'
require 'open-uri'
require 'yaml'

Ohai.plugin(:Elasticsearch) do
  provides 'elasticsearch', 'elasticsearch/cluster_name', 'elasticsearch/data'
  provides 'elasticsearch/http' 'elasticsearch/ip', 'elasticsearch/master'
  provides 'elasticsearch/mlockall' 'elasticsearch/node_name'

  depends  'platform', 'network'

  def collect_config
    config = '/opt/local/elasticsearch/config/elasticsearch.yml'
    output = {}

    type = MIME::Types.type_for(config).first.sub_type

    # Load support configuration
    # @return [Hash] Configuration content
    type == 'json' ? JSON.parse(::File.read(config)) : YAML.load_file(config)
  end

  def ip_address
    interfaces = network[:interfaces]

    interface  = case platform
    when 'smartos'
      interfaces.select { |iface| iface.match('net') }.sort.last
    when 'rhel'
      interfaces.select { |iface| iface.match('eth') }.sort.last
    end.first

    interfaces[interface][:addresses].keys.select do |addr|
      addr.match('^\d+\.')
    end.first
  end

  
  collect_data(:default) do
    config = collect_config

    elasticsearch Mash.new
    elasticsearch[:cluster_name] = config.fetch('cluster.name',       nil)
    elasticsearch[:data]         = config.fetch('node.data',          nil)
    elasticsearch[:http]         = config.fetch('http.enabled',       nil)
    elasticsearch[:ip]           = ip_address
    elasticsearch[:master]       = config.fetch('node.master',        nil)
    elasticsearch[:mlockall]     = config.fetch('bootstrap.mlockall', nil)
    elasticsearch[:node_name]    = config.fetch('node.name',          nil)
  end
end
