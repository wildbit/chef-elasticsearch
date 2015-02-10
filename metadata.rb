name             'elasticsearch_lwrp'
description      'Install & configure Elasticsearch'
license          'Apache 2.0'
maintainer       'Wildbit LLC'
maintainer_email 'sys-team@wildbit.com'
version          '0.1.95'
%w(wb-java resource-control).each do |dep|
  depends dep
end

%w(amazon centos rhel scientic smartos).each do |os|
  supports os
end

