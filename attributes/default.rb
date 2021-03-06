default[:elasticsearch][:checksum]         = 'efae7897367ac3fa8057d02fad31c72e215b6edef599b63e373d3ce0c1049a14'
default[:elasticsearch][:cluster]          = 'example'
default[:elasticsearch][:group][:name]     = 'elasticsearch'
default[:elasticsearch][:group][:gid]      = '700'
default[:elasticsearch][:http]             = true
default[:elasticsearch][:java][:stack]     = '256k'
default[:elasticsearch][:marvel]           = false
default[:elasticsearch][:multicast]        = false
default[:elasticsearch][:members]          = nil
default[:elasticsearch][:mlockall]         = true
default[:elasticsearch][:multicast]        = false
default[:elasticsearch][:port][:http]      = '9200'
default[:elasticsearch][:port][:transport] = '9300'
default[:elasticsearch][:service]          = 'elasticsearch'
default[:elasticsearch][:type]             = 'data'
default[:elasticsearch][:unicast]          = true
default[:elasticsearch][:user][:name]      = 'elasticsearch'
default[:elasticsearch][:user][:uid]       = '700'
default[:elasticsearch][:version]          = '1.5.2'

case node[:platform_family]
when 'rhel'
  default[:elasticsearch][:dir][:data]        = '/var/lib/elasticsearch'
  default[:elasticsearch][:dir][:home]        = '/opt/elasticsearch'
  default[:elasticsearch][:file][:pid]        = '/var/run/elasticsearch/elasticsearch.pid'
  default[:elasticsearch][:iface][:network]   = 'eth0'
  default[:elasticsearch][:iface][:transport] = 'eth1'
  default[:elasticsearch][:java][:home]       = '/usr'
  default[:elasticsearch][:java][:version]    = '1.8.0'
  default[:elasticsearch][:resources]         = {
    files:  { open:  '40000' },
    memory: { lock: 'unlimited', map: '262144' }
  }
when 'smartos'
  default[:elasticsearch][:dir][:data]        = '/var/lib/elasticsearch'
  default[:elasticsearch][:dir][:home]        = '/opt/local/elasticsearch'
  default[:elasticsearch][:iface][:network]   = 'net0'
  default[:elasticsearch][:iface][:transport] = 'net1'
  default[:elasticsearch][:file][:pid]        = '/var/tmp/elasticsearch/elasticsearch.pid'
  default[:elasticsearch][:java][:version]    = '1.7.6'
  default[:elasticsearch][:java][:home]       = "/opt/local/java/openjdk#{node[:elasticsearch][:java][:version].split('.')[1]}"
  default[:elasticsearch][:resources]         = { files:  { open: '40000' } }
end
default[:elasticsearch][:dir][:classes] = "#{node[:elasticsearch][:dir][:home]}/lib"
default[:elasticsearch][:dir][:log]     = '/var/log/elasticsearch'
default[:elasticsearch][:dir][:work]    = '/tmp/elasticsearch'
default[:elasticsearch][:dir][:plugin]  = "#{node[:elasticsearch][:dir][:home]}/plugins"
default[:elasticsearch][:file][:config] = "#{node[:elasticsearch][:dir][:home]}/config/elasticsearch.yml"
default[:elasticsearch][:source]        = "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-#{node[:elasticsearch][:version]}.tar.gz"

default[:elasticsearch][:log][:config]  = "#{node[:elasticsearch][:dir][:home]}/config/logging.yml"
default[:elasticsearch][:log][:file]    = '/var/log/elasticsearch/elasticsearch.log'
default[:elasticsearch][:log][:level]   = 'INFO'
