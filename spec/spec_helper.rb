require 'chefspec'
require 'chefspec/berkshelf'
require_relative '../libraries/helpers.rb'
require_relative '../libraries/resource_elasticsearch.rb'
require_relative '../libraries/provider_elasticsearch.rb'
require_relative '../libraries/provider_elasticsearch_rhel.rb'
require_relative '../libraries/provider_elasticsearch_smartos.rb'

RSpec.configure do |config|
  config.platform = 'smartos'
  config.version  = '5.11'
end
