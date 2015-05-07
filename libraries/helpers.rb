require 'chef/search/query'

module Elasticsearch
  module Helpers
    def network_host_address
      begin
        iface = node[:elasticsearch][:iface][:network]
        conf  = node[:network][:interfaces][iface][:addresses].select do |_, conf|
          conf[:family] == 'inet'
        end
        conf.keys.first
      rescue NoMethodError
        node[:ipaddress]
      end
    end

    def network_transport_address
      begin
        iface = node[:elasticsearch][:iface][:network]
        conf  = node[:network][:interfaces][iface][:addresses].select do |_, conf|
          conf[:family] == 'inet'
        end
        conf.keys.first
      rescue NoMethodError
        node[:ipaddress]
     end
    end

    def cluster
      if new_resource.marvel && current.type == 'monitor'
        "#{current.cluster}_marvel"
      else
        current.cluster
      end
    end

    # Returns Hash keyed by member type containing members of keyed type.
    # @return [Hash] Members of all types
    def members
      return new_resource.members if !new_resource.members.nil?
      output = {}

      # Search criteria
      query  = "chef_environment:#{node.chef_environment} "
      query << "AND (elasticsearch_cluster:#{current.cluster} "
      query << "OR elasticsearch_cluster_name:#{current.cluster})"

      all_members = ::Chef::Search::Query.new.search(:node, query).first

      %w(all client data master monitor).each do |type|
        output[type.to_sym] = all_members.select do |member|
          if type == 'client'
            member[:elasticsearch][:type] == 'data'
          else
            member[:elasticsearch][:type] == type
          end
        end
      end

      # Append self to classified members list
      unless output[current.type.to_sym].map(&:name).include?(node.name) && current.type != 'client'
        output[current.type.to_sym] << node
      end

      output.each do |type, hosts|
        hosts.map! do |host|
          if type.to_s.match('monitor')
            ip   = host[:ipaddress]
            port = current.http_port
          else
            ip   = transport_address(host)
            port = transport_port(host)
          end

          "#{ip}:#{port}"
        end.sort!
      end
      output
    end

    # Returns IP address used for inter-node communication.
    # @return [String] Transport IP address
    def transport_address(member)
      begin
        iface = member[:elasticsearch][:iface][:transport]
        conf  = member[:network][:interfaces][iface][:addresses].select do |_, conf|
          conf[:family] == 'inet'
        end
        conf.keys.first
      rescue NoMethodError
        member[:ipaddress]
     end
    end

    # Returns the given members transport port
    def transport_port(member)
      legacy = member[:elasticsearch].fetch('port', nil).nil?

      if legacy
        member[:elasticsearch][:module][:transport][:tcp][:port].split('-').first
      else
        member[:elasticsearch][:port][:transport]
      end
    end

    # @return [String] Command used to extract installation
    def cmd_decompress
      "tar -C #{current.home_dir} -xf #{installer_target} --strip-components 1"
    end

    # Recusively set installation permissions
    # @return [String] Command used to set install permissions
    def cmd_permissions
      "chown -R #{current.user}:#{current.group} #{current.home_dir}"
    end

    # Hash keyed with resource parameters.
    # @return [Hash] Hash providing necessary command, guard & expected return value.
    def cmd_reload_sysctl
      {
        command: "/sbin/sysctl -p /etc/sysctl.d/99-#{current.service_name}.conf",
        expects: [0, 255],
        guard:   "[ $(/sbin/sysctl -n vm.max_map_count) == #{current.resources.memory.map} ]"
      }
    end

    # Returns the size allocated for heap
    # @return [Fixum] Heap size allocated in megabytes
    def java_heap_size
      return current.java_heap if current.java_heap

      case node[:platform_family]
        when 'rhel'    then (0.5 * node[:memory][:total].to_f).to_i / 1024
        when 'smartos' then (0.5 * node[:memory][:total].to_f).to_i
      end
    end

    # Returns Java home directory
    # @return [String] Java home directory
    def java_home
      case node[:platform_family]
        when 'rhel'    then '/usr'
        when 'smartos' then '/opt/local'
      end
    end

    # Returns distribution specific Java package name
    # @return [String] Java package name
    def java_package
      version = current.java_version

      case node[:platform_family]
      when 'rhel'    then "java-#{current.java_version}-openjdk-headless"
      when 'smartos' then "openjdk#{current.java_version.split('.')[1]}"
      end
    end

    # Provides path to installation archive
    # @returns [String] Absolute path to installation archive
    def installer_target
      return current.source unless current.source.match('^http')

      directory = Chef::Config[:file_cache_path]
      filename  = ::File.basename(current.source)

      ::File.join(directory, filename)
    end

    # Returns a boolean describing the manifest state
    # @return [FalseClass, TrueClass] Manifest state
    def manifest_exists?
      response = shell_out("/usr/bin/svcs -a elasticsearch", returns: '0,1')
      response.exitstatus > 0 ? false : true
    end

    # Command used to delete service manifest
    def manifest_delete
      "/usr/sbin/svccfg delete -f #{current.service_name}"
    end

    # Command used to import service manifest
    def manifest_import
      "/usr/sbin/svccfg import #{service_file}"
    end

    # Returns the absolute path to the service file
    # @return [String] Path to service definition
    def service_file
      case node[:platform_family]
      when 'rhel'
        release  = node[:platform_version].to_i
        systemd  = '/etc/systemd/system/elasticsearch.service'
        sysvinit = '/etc/rc.d/init.d/elasticsearch'

        release >= 7 ? systemd : sysvinit
      when 'smartos'
        ::File.join(Chef::Config[:file_cache_path], 'elasticsearch')
      end
    end
  end
end
