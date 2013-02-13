#!/usr/bin/env ruby

require 'cinch'
require 'i18n'
require 'twitter'
require 'looper'
require 'getopt/std'
require 'mongo'

require File.dirname(__FILE__) + '/javabin/beer'
require File.dirname(__FILE__) + '/javabin/plugins'

I18n.load_path << Dir[File.join(File.dirname(__FILE__), 'locale', '*.{yml}')]
I18n.default_locale = :nb

opt = Getopt::Std.getopts("ta")

@test = opt["t"]

def get_config
  @config ||= YAML::load(File.open(File.join(File.dirname(__FILE__), 'config.yml')))

  if @test
    @config['test']
  else
    @config
  end
end

puts "Running with config:"

puts get_config

conf = get_config['bot']

tweeter = Tweeter.new(get_config['tweeter'])

if opt["a"]
  tweeter.tweet("Test", "TestLoc")
  exit
end

beer = Beer.new(get_config['beer'])

mongo = Mongo::MongoClient::from_uri(get_config['mongo']['uri'])
mongodb = mongo.db(get_config['mongo']['db'])

bot = Cinch::Bot.new do
  configure do |c|
    c.nick = conf['nick']
    c.realname = conf['real-name']
    c.user = conf['user-name']
    c.server = conf['hostname']
    c.channels = [conf['channel']]
    c.verbose = @test
    c.plugins.plugins = [TimeActivatedPlugin, JavaPilsPlugin, CommandListPlugin, UrlLoggerPlugin]
    c.plugins.options[JavaPilsPlugin] = {:beer => beer}
    c.plugins.options[TimeActivatedPlugin] = {:chan => conf['channel']}
    c.plugins.options[UrlLoggerPlugin] = {:mongo => mongodb}
  end
end

Thread.new { TimeActivatedAction.new(bot, beer, tweeter).run }
bot.start
