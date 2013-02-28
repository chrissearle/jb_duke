require "#{File.dirname(__FILE__)}/../lib/general/config_loader"

describe 'Load config' do
  context 'simple config' do
    it 'finds the correct config' do
      config = ConfigLoader.load_config(File.join(File.dirname(__FILE__), 'config', 'simple-config-1.yml'))

      config.size.should eq(3)

      (1..3).each do |i|
        key = "heading#{i}"

        config[key].size.should eq(1)

        config[key]['sub1']['sub'].should eq("sub")
      end
    end
  end

  context 'overridden config' do
    it 'finds the correct config' do
      config = ConfigLoader.load_config(File.join(File.dirname(__FILE__), 'config', 'simple-config-1.yml'), File.join(File.dirname(__FILE__), 'config', 'simple-config-2.yml'))

      config.size.should eq(4)

      (2..4).each do |i|
        key = "heading#{i}"

        config[key].size.should eq(1)

        config[key]['sub1']['sub'].should eq('sub')
      end

      config["heading1"]['sub1']['sub'].should eq('newsub')
      config["heading1"]['sub2']['sub'].should eq('sub')
    end
  end

  context 'overridden config with test' do
    it 'finds the correct config' do
      config = ConfigLoader.load_config(File.join(File.dirname(__FILE__), 'config', 'simple-config-3.yml'), File.join(File.dirname(__FILE__), 'config', 'simple-config-4.yml'), true)

      config.size.should eq(4)

      config.has_key?('test').should_not eq(true)

      config['heading1']['sub1']['sub'].should eq('testsub')
      config['heading2']['sub1']['sub'].should eq('testsub')
      config['heading2']['sub2']['sub'].should eq('testsub')
    end
  end
end

