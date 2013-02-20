class ::Hash
  def deep_merge(second)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    self.merge(second, &merger)
  end
end

class ConfigLoader
  def self.get_config(test = false)
    default_config = load_file('config-default.yml')
    local_config = load_file('config.yml')

    config = default_config.deep_merge(local_config)

    test_config = config.delete 'test'

    if test
      config = config.deep_merge(test_config)
    end

    config
  end

  private

  def self.load_file(filename)
    YAML::load(File.open(File.join(Dir.pwd, 'config', filename)))
  end
end