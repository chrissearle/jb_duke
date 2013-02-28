require 'cinch'
require "#{File.dirname(__FILE__)}/../lib/plugins/about_plugin"

describe 'About Plugin' do
  before(:all) do
    bot = Cinch::Bot.new do
      configure do |c|
        c.plugins.plugins = [AboutPlugin]
        c.plugins.options[AboutPlugin] = {:conf => {'usage' => '!about - About the bot', 'about' => 'A cinch/ruby based IRC bot. See https://github.com/chrissearle/jb_duke'}}
      end
    end

    plugin_list = bot.instance_variable_get(:@plugins)
    config = bot.instance_variable_get(:@config)
    plugin_list.register_plugins(config.plugins.plugins)

    @plugin = bot.plugins.find { |plugin| plugin.class.name == 'AboutPlugin' }
  end

  it 'should state that it has usage' do
    @plugin.respond_to?(:usage_hint).should eq(true)
  end

  it 'should have a usage hint' do
    @plugin.usage_hint.should eq('!about - About the bot')
  end

  it 'should respond' do
    msg = mock(Cinch::Message)
    msg.should_receive(:reply).with('A cinch/ruby based IRC bot. See https://github.com/chrissearle/jb_duke')
    @plugin.execute(msg)
  end
end
