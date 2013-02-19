class TimeActivatedAction
  include Looper

  def initialize(bot, beer, tweeter)
    @bot = bot
    @beer = beer
    @tweeter = tweeter

    @run = true
    @sleep = 60

    @limiter = {
        :beer => 1,
        :mentions => 5
    }

    @bot.loggers.debug "TimeActivatedAction - initialized"
  end

  def run
    @bot.loggers.debug "TimeActivatedAction - started"

    loopme(@sleep) do
      @bot.loggers.debug "TimeActivatedAction - run"

      now = Time.now.min

      if (now % @limiter[:beer]) == 0
        @bot.loggers.debug "TimeActivatedAction - check beer"

        locations = @beer.beer?

        locations.each do |location|
          if @beer.show_beer? location
            @tweeter.tweet(@beer.name(location), @beer.place(location))
            @bot.handlers.dispatch(:time_activated, nil, "#{@beer.name location} javaPils i dag - #{@beer.place location}")
          end
        end
      end

      if (now % @limiter[:mentions]) == 0
        @bot.loggers.debug "TimeActivatedAction - check mentions"

        @tweeter.mentions.each do |mention|
          @bot.handlers.dispatch(:time_activated, nil, mention)
        end
      end
    end
  end
end
