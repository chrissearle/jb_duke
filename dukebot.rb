#!/usr/bin/env ruby

require 'cinch'
require 'i18n'

def beer?
  weeknum = (I18n.l Time.now, :format => '%V').to_i
  dow = (I18n.l Time.now, :format => '%u').to_i
  
  dow == 2 && (weeknum % 2 == 1)
end

def showbeer?
  hour = (I18n.l Time.now, :format => '%H').to_i
  min = (I18n.l Time.now, :format => '%M').to_i
  
  hour == 11 && min == 19
end

class TimeActivatedThread
  def initialize(bot)
    @bot = bot
    @bot.loggers.debug "Initialized TimeActivatedThread with bot"
  end
  
  def start
    @bot.loggers.debug "Started TimeActivatedThread"
    while (true)
      sleep 60
      if beer?
        if showbeer?
          @bot.handlers.dispatch(:time_activated, nil, "Oslo javaPils i dag - Billabong")
        end
      end
    end
  end
end

class TimeActivatedPlugin
  include Cinch::Plugin

  listen_to :time_activated

  def listen(m, message)
    debug "I got message #{message}"
    Channel("#just-testing").send message
  end
end

class JavaPilsPlugin
  include Cinch::Plugin
  
  match /pils\?/

  def execute(m)
    if beer?
      m.reply "Ja! Oslo javaPils i dag - Billabong"
    else
      m.reply "Ikke i dag :("
    end
  end
end

bot = Cinch::Bot.new do
  configure do |c|
    c.nick = "jb_duke"
    c.realname = "javaBin Duke Bot"
    c.user = "jb_duke"
    c.server = "irc.underworld.no"
    c.channels = ["#just-testing"]
    c.verbose = true
    c.plugins.plugins = [TimeActivatedPlugin, JavaPilsPlugin]
  end
end

Thread.new { TimeActivatedThread.new(bot).start }
bot.start
