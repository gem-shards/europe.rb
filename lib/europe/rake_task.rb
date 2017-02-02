module Europe
  # RakeTask
  module RakeTask
    files = File.expand_path(File.join(File.dirname(__FILE__), 'tasks/*.rake'))
    Dir[files].each { |ext| load ext } if defined?(Rake)
  end
end
