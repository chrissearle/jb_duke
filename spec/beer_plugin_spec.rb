require 'cinch'
require 'general/string_expander'
require 'beer/beer'
require 'plugins/java_pils_plugin'

require 'i18n'

I18n.load_path << Dir[File.join(File.dirname(__FILE__), '..', 'locale', '*.{yml}')]
I18n.default_locale = :nb

describe 'Java Pils Plugin' do
  before(:all) do

    conf = {
        'usage' => '!pils? - Check for javaPils today',
        'announce' => 'NAME javaPils i dag - PLACE',
        'reply' => 'Ja! NAME javaPils i dag - PLACE',
        'no-reply' => 'Ikke i dag :( Hvis ikke noen har lyst ?',
        'tweet' => 'NAME javaPils i dag - %d. %b - PLACE'
    }

    @beerconf = {
        'locations' => {
            'oslo' => {
                'day-of-week' => 2,
                'announce-hour' => 10,
                'announce-min' => 0,
                'week' => 'odd',
                'display-name' => 'Oslo',
                'place' => 'Billabong'
            }
        }
    }

    bot = Cinch::Bot.new do
      configure do |c|
        c.plugins.plugins = [JavaPilsPlugin]
        c.plugins.options[JavaPilsPlugin] = {:conf => conf, :beer => nil, :chan => nil, :tweeter => nil}
      end
    end

    bot.loggers = Cinch::LoggerList.new()
    bot.loggers << Cinch::Logger::FormattedLogger.new(open('/dev/null', File::WRONLY | File::APPEND))

    plugin_list = bot.instance_variable_get(:@plugins)
    config = bot.instance_variable_get(:@config)
    plugin_list.register_plugins(config.plugins.plugins)

    @plugin = bot.plugins.find { |plugin| plugin.class.name == 'JavaPilsPlugin' }
  end

  it 'should state that it has usage' do
    @plugin.respond_to?(:usage_hint).should eq(true)
  end

  it 'should have a usage hint' do
    @plugin.usage_hint.should eq('!pils? - Check for javaPils today')
  end


  describe 'Response' do
    context 'not beer' do
      it 'should respond correctly' do
        c = @beerconf

        now = Time.now

        c['locations']['oslo']['day-of-week'] = ((I18n.l now, :format => '%u').to_i) + 1

        @plugin.bot.instance_variable_get(:@config).plugins.options[@plugin.class][:beer] = Beer.new(c)

        msg = mock(Cinch::Message)
        msg.should_receive(:reply).with('Ikke i dag :( Hvis ikke noen har lyst ?')
        @plugin.execute(msg)
      end
    end

    context 'beer' do
      it 'should respond correctly' do
        c = @beerconf

        now = Time.now

        c['locations']['oslo']['announce-hour'] = ((I18n.l now, :format => '%H').to_i)
        c['locations']['oslo']['announce-min'] = ((I18n.l now, :format => '%M').to_i)
        c['locations']['oslo']['day-of-week'] = ((I18n.l now, :format => '%u').to_i)

        if (I18n.l Time.now, :format => '%V').to_i % 2 == 0
          c['locations']['oslo']['week'] = 'even'
        end

        @plugin.bot.instance_variable_get(:@config).plugins.options[@plugin.class][:beer] = Beer.new(c)

        msg = mock(Cinch::Message)
        msg.should_receive(:reply).with('Ja! Oslo javaPils i dag - Billabong')
        @plugin.execute(msg)
      end
    end
  end

  describe 'should trigger correctly' do

    context 'not beer' do
      it 'should not trigger' do
        c = @beerconf

        now = Time.now

        c['locations']['oslo']['day-of-week'] = ((I18n.l now, :format => '%u').to_i) + 1

        @plugin.bot.instance_variable_get(:@config).plugins.options[@plugin.class][:beer] = Beer.new(c)

        responses = @plugin.timed_responses

        responses.should eq([])
      end
    end

    context 'beer' do
      it 'should trigger correctly' do
        c = @beerconf

        now = Time.now

        c['locations']['oslo']['announce-hour'] = ((I18n.l now, :format => '%H').to_i)
        c['locations']['oslo']['announce-min'] = ((I18n.l now, :format => '%M').to_i)
        c['locations']['oslo']['day-of-week'] = ((I18n.l now, :format => '%u').to_i)

        if (I18n.l Time.now, :format => '%V').to_i % 2 == 0
          c['locations']['oslo']['week'] = 'even'
        end

        @plugin.bot.instance_variable_get(:@config).plugins.options[@plugin.class][:beer] = Beer.new(c)

        responses = @plugin.timed_responses

        responses.should eq(["Oslo javaPils i dag - 28. feb - Billabong"])
      end
    end
  end
end