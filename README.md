#### Elasticsearch

The Elasticsearch cookbook facilitates the installation and configuration of an Elasticsearch instance.

##### Requirements

###### Cookbooks

* java
* resource-control	

##### Software
* Chef (>= 0.11.0)

###### Platform

* RHEL
* SmartOS

##### Resources & Providers

This cookbook includes the following resources and respective providers:

* elasticsearch
* elasticsearch_plugin

The ```elasticsearch``` resource/provider facilate the configuration and installation of Elasticsearch. Defaults are provided, however they may be overriden.

* Set home directory
 
```
elasticsearch '1.4.2' do
  home_dir '/opt/elasticsearch-1.4.2'
end
```

* Set user & group

```
elasticsearch '1.4.2' do
  user  'elastic'
  group 'elastic'
end
```

* Set logging directory

```
elasticsearch '1.4.2' do
  log_dir '/opt/local/elasticsearch/logs'
end
```

In addtion to ```elasticsearch```, ```elasticsearch_plugin``` is provided, facilitating plugin installation and removal.

* Install Marvel plugin

```
elasticsearch_plugin 'elasticsearch/marvel/latest'
```

* Install latest Marvel plugin with different plugin executable

```
elasticsearch_plugin 'elasticsearch/marvel/latest' do
  plugin_binary '/usr/local/elasticsearch/bin/plugin'
end
```

* Install Marvel plugin with provided version

```
elasticsearch_plugin 'elasticsearch/marvel/0.1.0'
```


##### elasticsearch Attributes

__Directories__

<table>
<th>Directory</th>
<th>Description</th>
<th>Default - RHEL</th>
<th>Default - SmartOS</th>
<tr>
<td>data_dir</td>
<td>Data directory</td>
<td>/var/lib/elasticsearch</td>
<td>/var/db/elasticsearch</td>
</tr>
<tr>
<td>home_dir</td>
<td>Home directory</td>
<td>/opt/elasticsearch</td>
<td>/opt/local/elasticsearch</td>
</tr>
<tr>
<td>log_dir</td>
<td>Log directory</td>
<td>/var/log/elasticsearch</td>
<td>/var/log/elasticsearch</td>
</tr>
<td>work_dir</td>
<td>Working directory</td>
<td>/tmp/elasticsearch</td>
<td>/var/tmp/elasticsearch</td>
</tr>
</table>

__Network__

<table>
<th>Attribute</th>
<th>Description</th>
<th>Default - RHEL</th>
<th>Default - SmartOS</th>
<tr>
<td>http_port</td>
<td>HTTP Port</td>
<td>9200</td>
<td>9200</td>
</tr>
<tr>
<td>transport_port</td>
<td>Transport port</td>
<td>9300-9400</td>
<td>9300-9400</td>
</tr>
<tr>
<td>multicast</td>
<td>Multicast discovery</td>
<td>false</td>
<td>false</td>
</tr>
<tr>
<td>unicast</td>
<td>Unicast discovery</td>
<td>true</td>
<td>true</td>
</tr>
</table>

__Options__

<table>
<th>Option</th>
<th>Description</th>
<th>Default - RHEL</th>
<th>Default - SmartOS</th>
<tr>
<td>cluster</td>
<td>Cluster name</td>
<td>development</td>
<td>development</td>
</tr>
<tr>
<td>log_level</td>
<td>Logging verbosity</td>
<td>DEBUG</td>
<td>DEBUG</td>
</tr>
<tr>
<td>marvel</td>
<td>Marvel support</td>
<td>true</td>
<td>true</td>
</tr>
<tr>
<td>max_locked_memory</td>
<td>Maximum memory locked</td>
<td>unlimited</td>
<td>unlimited</td>
</tr>
<tr>
<td>max_memory_map</td>
<td>Maximum memory mapped files</td>
<td>262144</td>
<td>262144</td>
</tr>
<tr>
<td>max_open_files</td>
<td>Maximum open files</td>
<td>65535</td>
</tr>
<tr>
<td>members</td>
<td>Collection of members</td>
<td>nil</td>
<td>nil</td>
</tr>
<tr>
<td>service_name</td>
<td>Service name</td>
<td>elasticsearch</td>
<td>elasticsearch</td>
</tr>
<tr>
<td>shell</td>
<td>Shell</td>
<td>/bin/bash</td>
<td>/usr/bin/bash</td>
</tr>
<tr>
<td>type</td>
<td>Member type</td>
<td>data</td>
<td>data</td>
</tr>
<tr>
<td>version</td>
<td>Version managed</td>
<td>1.4.2</td>
<td>1.4.2</td>
</table>

__User & Group__

<table>
<th>Attribute</th>
<th>Description</th>
<th>Default - RHEL</th>
<th>Default - SmartOS</th>
<tr>
<td>user</td>
<td>User to execute process as</td>
<td>elasticsearch</td>
<td>elasticsearch</td>
</tr>
<tr>
<td>group</td>
<td>Group to execute process as</td>
<td>elasticsearch</td>
<td>elasticsearch</td>
</tr>
<tr>
<td>uid</td>
<td>User UID</td>
<td>700</td>
<td>700</td>
</tr>
<tr>
<td>gid</td>
<td>Group GID</td>
<td>700</td>
<td>700</td>
</tr>
</table>

##### Usage

This cookbook conforms to the application/library convention, as a result it's recommended that this cookbook be augmented with a site-specific cookbook.

However, should the defaults be acceptable to your environment simple include the recipe within the desired node's run list.

```
$ knife node run_list add 'recipe[elasticsearch]'
```