default[:elasticsearch][:checksum]         = 'a3158d474e68520664debaea304be22327fc7ee1f410e0bfd940747b413e8586'
default[:elasticsearch][:cluster]          = 'example'
default[:elasticsearch][:group][:name]     = 'elasticsearch'
default[:elasticsearch][:group][:gid]      = '700'
default[:elasticsearch][:http]             = true
default[:elasticsearch][:java][:stack]     = '256k'
default[:elasticsearch][:java][:version]   = '8'
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
default[:elasticsearch][:version]          = '1.4.4'

case node[:platform_family]
when 'rhel'
  default[:elasticsearch][:dir][:data]     = '/var/lib/elasticsearch'
  default[:elasticsearch][:dir][:home]     = '/opt/elasticsearch'
  default[:elasticsearch][:file][:pid]     = '/var/run/elasticsearch/elasticsearch.pid'
  default[:elasticsearch][:interface]      = 'eth1'
  default[:elasticsearch][:java][:home]    = '/usr'
  default[:elasticsearch][:java][:version] = '1.8.0'
  default[:elasticsearch][:resources]      = {
    files:  { open:  '40000' },
    memory: { lock: 'unlimited', map: '262144' }
  }
when 'smartos'
  default[:elasticsearch][:dir][:data]     = '/var/db/elasticsearch'
  default[:elasticsearch][:dir][:home]     = '/opt/local/elasticsearch'
  default[:elasticsearch][:interface]      = 'net1'
  default[:elasticsearch][:file][:pid]     = '/var/tmp/elasticsearch/elasticsearch.pid'
  default[:elasticsearch][:java][:version] = '1.7.6'
  default[:elasticsearch][:java][:home]    = "/opt/local/java/openjdk#{node[:elasticsearch][:version]}"
  default[:elasticsearch][:resources]      = {
    files:  { open: '40000' }
  }
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
