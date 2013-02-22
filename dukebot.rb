#!/usr/bin/env ruby

require 'cinch'
require 'i18n'
require 'twitter'
require 'getopt/std'
require 'mongo'
require 'pp'

require 'dukelibs'

I18n.load_path << Dir[File.join(Dir.pwd, 'locale', '*.{yml}')]
I18n.default_locale = :nb

opt = Getopt::Std.getopts("t")

config = ConfigLoader.get_config(opt["t"])

puts "Running with config:"
pp config
$stdout.flush

tweeter = Tweeter.new(config['tweeter'])
beer = Beer.new(config['beer'])
mongo_db = Mongo::MongoClient::from_uri(config['mongo']['uri']).db(config['mongo']['db'])


plugin_conf = config['plugins']

conf = config['bot']

bot = Cinch::Bot.new do
  configure do |c|
    c.nick = conf['nick']
    c.realname = conf['real-name']
    c.user = conf['user-name']
    c.server = conf['hostname']
    c.channels = [conf['channel']]
    c.verbose = opt["t"]
    c.plugins.plugins = [JavaPilsPlugin, CommandListPlugin, UrlLoggerPlugin, TwitterPlugin, AboutPlugin, FridayPlugin]
    c.plugins.options[JavaPilsPlugin]    = {:conf => plugin_conf['java-pils'], :beer => beer, :chan => conf['channel'], :tweeter => tweeter}
    c.plugins.options[TwitterPlugin]     = {:conf => plugin_conf['twitter'], :chan => conf['channel'], :tweeter => tweeter}
    c.plugins.options[UrlLoggerPlugin]   = {:conf => plugin_conf['url-logger'], :mongo => mongo_db}
    c.plugins.options[CommandListPlugin] = {:conf => plugin_conf['command-list'], :mongo => mongo_db}
    c.plugins.options[AboutPlugin]       = {:conf => plugin_conf['about']}
    c.plugins.options[FridayPlugin]      = {:conf => plugin_conf['friday']}
  end

  on :connect do
    tweeter.enable()
  end
end

bot.start
