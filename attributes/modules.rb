default[:elasticsearch][:modules] = {
  'discovery.zen.ping.timeout'                    => '60s',
  'discovery.zen.fd.ping_interval'                => '5s',
  'discovery.zen.fd.ping_retries'                 => '5',
  'discovery.zen.fd.ping_timeout'                 => '60s',
  'index.merge.policy.max_merge_at_once'          => '8',
  'index.merge.policy.max_merge_at_once_explicit' => '25',
  'index.merge.scheduler.max_thread_count'        => '1',
  'index.refresh_interval'                        => '5s',
  'index.translog.flush_threshold_period'         => '5s',
  'indices.memory.index_buffer_size'              => '15%',
  'script.disable_dynamic'                        => false,
  'transport.tcp.connect_timeout'                 => '90s'
}
