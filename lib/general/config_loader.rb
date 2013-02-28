class ::Hash
  def deep_merge(second)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    self.merge(second, &merger)
  end
end

class ConfigLoader
  def self.get_config(test = false)
    load_config(File.join(Dir.pwd, 'config', 'config-default.yml'), File.join(Dir.pwd, 'config', 'config.yml'), test)
  end

  def self.load_config(default_config_file, local_config_file = nil, test = false)
    config = load_file(default_config_file)

    unless local_config_file.nil?
      config = config.deep_merge(load_file(local_config_file))
    end

    if config.has_key? 'test'
      test_config = config.delete 'test'

      if test
        config = config.deep_merge(test_config)
      end
    end

    config
  end

  private

  def self.load_file(filename)
    YAML::load(File.open(filename))
  end
end