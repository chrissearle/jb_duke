require 'cinch'
require "#{File.dirname(__FILE__)}/../lib/plugins/friday_plugin"

require 'i18n'

I18n.load_path << Dir[File.join(File.dirname(__FILE__), '..', 'locale', '*.{yml}')]
I18n.default_locale = :nb

describe 'Friday Plugin' do
  before(:all) do

    conf = {
        'usage' => '!isitfriday? - Is it friday?',
        'friday' => "Ja! It's Friday, Friday, Gotta get down on Friday",
        'not-friday' => 'Nei.',
        'dow' => 5
    }

    bot = Cinch::Bot.new do
      configure do |c|
        c.plugins.plugins = [FridayPlugin]
        c.plugins.options[FridayPlugin] = {:conf => conf}
      end
    end

    bot.loggers = Cinch::LoggerList.new()
    bot.loggers << Cinch::Logger::FormattedLogger.new(IO.new(IO.sysopen("/dev/null", "w"),"w"))

    plugin_list = bot.instance_variable_get(:@plugins)
    config = bot.instance_variable_get(:@config)
    plugin_list.register_plugins(config.plugins.plugins)

    @plugin = bot.plugins.find { |plugin| plugin.class.name == 'FridayPlugin' }
  end

  it 'should state that it has usage' do
    @plugin.respond_to?(:usage_hint).should eq(true)
  end

  it 'should have a usage hint' do
    @plugin.usage_hint.should eq('!isitfriday? - Is it friday?')
  end

  context 'not friday' do
    it 'should respond correctly' do
      @plugin.bot.instance_variable_get(:@config).plugins.options[@plugin.class][:conf]['dow'] = ((I18n.l Time.now, :format => '%u').to_i + 1)

      msg = mock(Cinch::Message)
      msg.should_receive(:reply).with('Nei.')
      @plugin.execute(msg)
    end
  end
  context 'friday' do
    it 'should respond correctly' do
      @plugin.bot.instance_variable_get(:@config).plugins.options[@plugin.class][:conf]['dow'] = (I18n.l Time.now, :format => '%u').to_i

      msg = mock(Cinch::Message)
      msg.should_receive(:reply).with("Ja! It's Friday, Friday, Gotta get down on Friday")
      @plugin.execute(msg)
    end
  end
end
