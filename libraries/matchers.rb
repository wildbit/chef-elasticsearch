if defined?(ChefSpec)
  def create_elasticsearch(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:elasticsearch, :create, resource_name)
  end

  def delete_elasticsearch(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:elasticsearch, :delete, resource_name)
  end
end
