require 'beer/beer'

require 'i18n'

I18n.load_path << Dir[File.join(File.dirname(__FILE__), '..', 'locale', '*.{yml}')]
I18n.default_locale = :nb

config = {
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

describe 'Beer locations' do
  context 'unknown location' do
    it 'should give sensible default info' do
      beer = Beer.new(config)

      beer.info('bergen').should eq({:place => "Unknown location", :name => "Unknown group"})
    end
  end

  context 'known location' do
    it 'should give correct info' do
      beer = Beer.new(config)

      beer.info('oslo').should eq({:place => "Billabong", :name => "Oslo"})
    end

  end
end

describe 'Beer trigger on time/date' do
  context 'unknown location' do
    it 'should not trigger' do
      beer = Beer.new(config)

      beer.show_beer?('bergen').should eq(false)
    end
  end

  context 'known location, mismatching date/time' do
    it 'should not trigger' do
      c = config

      c['locations']['oslo']['announce-hour'] = ((I18n.l Time.now, :format => '%H').to_i + 1)

      beer = Beer.new(c)

      beer.show_beer?('oslo').should eq(false)
    end
  end

  context 'known location, matching date/time' do
    it 'should trigger' do
      c = config

      now = Time.now

      c['locations']['oslo']['announce-hour'] = ((I18n.l now, :format => '%H').to_i)
      c['locations']['oslo']['announce-min'] = ((I18n.l now, :format => '%M').to_i)

      beer = Beer.new(c)

      beer.show_beer?('oslo').should eq(true)
    end
  end
end

describe 'Beer check' do
  context 'unknown location' do
    it 'should not list anything' do
      beer = Beer.new(config)

      beer.beer?('bergen').should eq([])
    end
  end

  context 'known location, mismatching date/time' do
    it 'should not list anything' do
      c = config

      c['locations']['oslo']['day-of-week'] = ((I18n.l Time.now, :format => '%u').to_i + 1)

      beer = Beer.new(c)

      beer.beer?('oslo').should eq([])
    end
  end

  context 'all locations, mismatching date/time' do
    it 'should not list anything' do
      c = config

      c['locations']['oslo']['day-of-week'] = ((I18n.l Time.now, :format => '%u').to_i + 1)

      beer = Beer.new(c)

      beer.beer?().should eq([])
    end
  end

  context 'known location, matching date/time' do
    it 'should list location' do
      c = config

      now = Time.now

      c['locations']['oslo']['announce-hour'] = ((I18n.l now, :format => '%H').to_i)
      c['locations']['oslo']['announce-min'] = ((I18n.l now, :format => '%M').to_i)
      c['locations']['oslo']['day-of-week'] = ((I18n.l now, :format => '%u').to_i)

      if (I18n.l Time.now, :format => '%V').to_i % 2 == 0
        c['locations']['oslo']['week'] = 'even'
      end

      beer = Beer.new(c)

      beer.beer?('oslo').should eq(['oslo'])
    end
  end

  context 'all locations, matching date/time' do
    it 'should list location' do
      c = config

      now = Time.now

      c['locations']['oslo']['announce-hour'] = ((I18n.l now, :format => '%H').to_i)
      c['locations']['oslo']['announce-min'] = ((I18n.l now, :format => '%M').to_i)
      c['locations']['oslo']['day-of-week'] = ((I18n.l now, :format => '%u').to_i)

      if (I18n.l Time.now, :format => '%V').to_i % 2 == 0
        c['locations']['oslo']['week'] = 'even'
      end

      beer = Beer.new(c)

      beer.beer?().should eq(['oslo'])
    end
  end
end
