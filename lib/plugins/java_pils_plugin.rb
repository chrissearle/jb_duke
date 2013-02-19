class JavaPilsPlugin
  include Cinch::Plugin

  set :required_options, [:beer, :chan, :tweeter]

  match /pils\?/

  timer 60, method: :timed

  def usage_hint
    "!pils? - Check for javaPils today"
  end

  def timed
    debug "Timed - check beer"

    beer = config[:beer]
    tweeter = config[:tweeter]
    chan = config[:chan]

    locations = beer.beer?

    debug "Timed - saw #{locations}"

    locations.each do |location|
      if beer.show_beer? location
        tweeter.tweet(beer.name(location), beer.place(location))
        Channel(config[:chan]).send "#{@beer.name location} javaPils i dag - #{@beer.place location}"
      end
    end
  end

  def execute(m)
    beer = config[:beer]

    locations = beer.beer?

    debug "Saw #{locations}"
    
    locations.each do |location|
      m.reply "Ja! #{beer.name location} javaPils i dag - #{beer.place location}"
    end

    if locations.size == 0
      m.reply "Ikke i dag :("
    end
  end
end
