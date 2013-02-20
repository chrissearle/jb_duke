#!/usr/bin/env ruby

require 'cinch'
require 'i18n'
require 'twitter'
require 'getopt/std'
require 'mongo'
require 'pp'

require 'dukelibs'

def log(prefix, item)
  puts prefix
  pp item
  $stdout.flush
end

I18n.load_path << Dir[File.join(File.dirname(__FILE__), 'locale', '*.{yml}')]
I18n.default_locale = :nb

opt = Getopt::Std.getopts("ta")

config = ConfigLoader.get_config(opt["t"])

log "Running with config:", config

tweeter = Tweeter.new(config['tweeter'])

if opt["a"]
  tweeter.enable()
  tweeter.tweet("Test", "TestLoc")
  exit
end



beer = Beer.new(config['beer'])



mongodb = Mongo::MongoClient::from_uri(config['mongo']['uri']).db(config['mongo']['db'])



conf = config['bot']

bot = Cinch::Bot.new do
  configure do |c|
    c.nick = conf['nick']
    c.realname = conf['real-name']
    c.user = conf['user-name']
    c.server = conf['hostname']
    c.channels = [conf['channel']]
    c.verbose = opt["t"]
    c.plugins.plugins = [JavaPilsPlugin, CommandListPlugin, UrlLoggerPlugin, TwitterPlugin]
    c.plugins.options[JavaPilsPlugin] = {:beer => beer, :chan => conf['channel'], :tweeter => tweeter}
    c.plugins.options[TwitterPlugin] = {:chan => conf['channel'], :tweeter => tweeter}
    c.plugins.options[UrlLoggerPlugin] = {:mongo => mongodb}
  end

  on :connect do
    tweeter.enable()
  end
end

bot.start
