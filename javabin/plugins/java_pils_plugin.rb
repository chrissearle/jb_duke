class JavaPilsPlugin
  include Cinch::Plugin

  set :required_options, [:beer]

  match /pils\?/

  def usage_hint
    "!pils? - Check for javaPils today"
  end

  def execute(m)
    beer = config[:beer]

    locations = beer.beer?

    debug "JavaPilsPlugin - saw #{locations}"
    
    locations.each do |location|
      m.reply "Ja! #{beer.name location} javaPils i dag - #{beer.place location}"
    end

    if locations.size == 0
      m.reply "Ikke i dag :("
    end
  end
end
