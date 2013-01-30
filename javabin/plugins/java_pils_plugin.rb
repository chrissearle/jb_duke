class JavaPilsPlugin
  include Cinch::Plugin

  set :required_options, [:beer]

  match /pils\?/

  def execute(m)
    beer = config[:beer]

    locations = beer.beer?

    locations.each do |location|
      m.reply "Ja! #{beer.name location} javaPils i dag - #{beer.place location}"
    end

    if locations.size == 0
      m.reply "Ikke i dag :("
    end
  end
end
