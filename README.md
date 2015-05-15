### Elasticsearch

The Elasticsearch cookbook is a library cookbook that is intended to be included in an application cookbook. Two resource primitives (resources) are provided for use within recipes. 

* elasticsearch
* elasticsearch_plugin

#### Requirements
----

##### Cookbooks

* [resource-control](https://github.com/wanelo-chef/resource-control)

##### Platforms

* CentOS
* RHEL 
* SmartOS

#### Resources
----
##### elasticsearch



* ```checksum``` - Installation archive checksum
* ```cluster``` - Cluster name
* ```config_file``` - Configuration file location
* ```data_dir``` - Directory containing data files
* ```gid``` - GID of group
* ```group``` Group to run as
* ```home_dir``` - Installation directory
* ```http``` - Enable HTTP API
* ```http_port``` - HTTP API port
* ```java_heap``` - Java heap size
* ```java_home``` - Java home
* ```log_config``` - Log configuration file location
* ```log_dir``` - Directory containing log files
* ```log_file``` - Log file
* ```log_level``` - Log verbosity
* ```marvel``` - Enable monitoring via Marvel
* ```mlockall``` - Lock process address space into memory
* ```members``` - Cluster members
* ```modules``` - Modules 
* ```multicast``` - Multicast support
* ```network_interface``` - Network interface to listen on
* ```pid_file```- Location of PID file
* ```plugin_dir``` - Directory containing plugins
* ```resources``` - Resource contraints
* ```service_name``` - Name of service
* ```source``` - URL of installation archive
* ```transport_interface``` - Interface used for inter-node communication
* ```transport_port``` - Port used for inter-node communication
* ```type``` - Operating type of node (all, client, data, master, monitor)
* ```uid```- UID of user
* ```unicast``` - Unicast support
* ```user``` - User to run as
* ```version``` - Version
* ```work_dir``` - Working directory

##### elasticsearch_plugin

* ```plugin_binary``` - Location of plugin executable
* ```plugin_name``` - Name of plugin
* ```plugin_version``` - Version of plugi

#### Usage

As mentioned above the cookbook is intended to be included within an application cookbook. Should the the defaults to unsuitable they may be overriden.

```
# modify install archive checksum
set[:elasticsearch][:checksum] = '1122334455'

# modify HTTP port
set[:elasticsearch][:http_port] = '9400'

# disable marvel
set[:elasticsearch][:marvel] = false
```

##### Member Discovery

Members may be provided through the ```members``` parameter, however it may be useful to autodiscover members. Nodes will be discovered based the Chef environment and cluster name. Currently there is no means to alter search criteria through the resource.
