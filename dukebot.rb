#!/usr/bin/env ruby

require 'cinch'
require 'i18n'
require 'looper'
require 'getopt/std'

require File.dirname(__FILE__) + '/javabin/beer'

opt = Getopt::Std.getopts("t")

@test = opt["t"]

def get_config
  @config ||= YAML::load(File.open(File.join(File.dirname(__FILE__), 'config.yml')))

  if @test
    @config['test']
  else
    @config
  end
end

def get_beer
  @beer ||= Beer.new(get_config)
end

class TimeActivatedAction
  include Looper
  
  def initialize(bot)
    @bot = bot
    @beer = get_beer
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
          @bot.handlers.dispatch(:time_activated, nil, "#{@beer.name location} javaPils i dag - #{@beer.place location}")
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
    Channel("#java.no").send message
  end
end

class JavaPilsPlugin
  include Cinch::Plugin

  match /pils\?/

  def execute(m)
    beer = get_beer
    locations = beer.beer?

    locations.each do |location|
      m.reply "Ja! #{beer.name location} javaPils i dag - #{beer.place location}"
    end

    if locations.size == 0
      m.reply "Ikke i dag :("
    end
  end
end

conf = get_config['bot']

bot = Cinch::Bot.new do
  configure do |c|
    c.nick = conf['nick']
    c.realname = conf['real-name']
    c.user = conf['user-name']
    c.server = conf['hostname']
    c.channels = [conf['channel']]
    c.verbose = @test
    c.plugins.plugins = [TimeActivatedPlugin, JavaPilsPlugin]
  end
end

Thread.new { TimeActivatedAction.new(bot).run }
bot.start
