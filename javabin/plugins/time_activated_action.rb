class TimeActivatedAction
  include Looper
  
  def initialize(bot, beer, tweeter)
    @bot = bot
    @beer = beer
    @tweeter = tweeter

    @run = true
    @sleep = 60
    
    @bot.loggers.debug "TimeActivatedAction - initialized"
  end

  def run
    @bot.loggers.debug "TimeActivatedAction - started"
    
    loopme(@sleep) do
      @bot.loggers.debug "TimeActivatedAction - run"
      
      locations = @beer.beer?

      locations.each do |location|
        if @beer.show_beer? location
          @tweeter.tweet(@beer.name(location), @beer.place(location))
          @bot.handlers.dispatch(:time_activated, nil, "#{@beer.name location} javaPils i dag - #{@beer.place location}")
        end
      end
    end
  end
end
