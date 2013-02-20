class JavaPilsPlugin
  include Cinch::Plugin

  set :required_options, [:conf, :beer, :chan, :tweeter]

  match /pils\?/

  timer 60, method: :timed

  def usage_hint
    config[:conf]["usage"]
  end

  def timed
    debug "Timed - check beer"

    beer = config[:beer]
    tweeter = config[:tweeter]
    chan = config[:chan]

    locations = beer.beer?

    debug "Timed - saw #{locations}"

    message = I18n.l Time.now, :format => config[:conf]["tweet"]

    locations.each do |location|
      if beer.show_beer? location
        tweeter.tweet(message.format_string_with_hash(beer.info(location)))
        Channel(chan).send(config[:conf]["announce"].format_string_with_hash(beer.info(location)))
      end
    end
  end

  def execute(m)
    beer = config[:beer]

    locations = beer.beer?

    debug "Saw #{locations}"

    locations.each do |location|
      m.reply(config[:conf]["reply"].format_string_with_hash(beer.info(location)))
    end

    if locations.size == 0
      m.reply config[:conf]['no-reply']
    end
  end
end
