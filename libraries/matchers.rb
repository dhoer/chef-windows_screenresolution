if defined?(ChefSpec)
  def run_windows_screenresolution(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_screenresolution, :run, resource_name)
  end
end
