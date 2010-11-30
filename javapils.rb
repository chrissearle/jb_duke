require 'rubygems'
require 'i18n'
require 'twitter'
require 'yaml'
require 'getopt/std'

config = YAML::load(File.open(File.join(File.dirname(__FILE__), 'javapils.yaml')))

config_params = config

opt = Getopt::Std.getopts("ct")
config_params = config['test'] if opt["t"]

CONSUMER_TOKEN = config_params['twitter']['consumer']['token']
CONSUMER_SECRET = config_params['twitter']['consumer']['secret']
ACCESS_TOKEN = config_params['twitter']['access']['token']
ACCESS_SECRET = config_params['twitter']['access']['secret']

if opt["c"]
  puts "CONSUMER TOKEN : #{CONSUMER_TOKEN}"
  puts "CONSUMER SECRET: #{CONSUMER_SECRET}"
  puts "ACCESS TOKEN   : #{ACCESS_TOKEN}"
  puts "ACCESS SECRET  : #{ACCESS_SECRET}"
  puts "FORMAT         : #{config_params['message']['format']}"
  exit
end

I18n.load_path << Dir[ File.join(File.dirname(__FILE__), 'locale', '*.{yml}') ]

# set default locale to something other than :en
I18n.default_locale = :nb

dow = I18n.l Time.now, :format => "%a"
weeknum = I18n.l Time.now, :format => "%W"

if ((dow == "tir") and (weeknum.to_i % 2 == 1)) or opt["t"]
  message = I18n.l Time.now, :format => config_params['message']['format']
  
  Twitter.configure do |config|
    config.consumer_key = CONSUMER_TOKEN
    config.consumer_secret = CONSUMER_SECRET
    config.oauth_token = ACCESS_TOKEN
    config.oauth_token_secret = ACCESS_SECRET
  end

  client = Twitter::Client.new
  
  client.update(message)
end
