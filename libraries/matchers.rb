if defined?(ChefSpec)
  def install_elasticsearch(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:elasticsearch, :install, resource_name)
  end

  def remove_elasticsearch(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:elasticsearch, :remove, resource_name)
  end
end
