require 'rubygems'
require 'i18n'
require 'twitter'
require 'yaml'

config = YAML::load(File.open(File.join(File.dirname(__FILE__), 'javapils.yaml')))

CONSUMER_TOKEN = config['twitter']['consumer']['token']
CONSUMER_SECRET = config['twitter']['consumer']['secret']
ACCESS_TOKEN = config['twitter']['access']['token']
ACCESS_SECRET = config['twitter']['access']['secret']

I18n.load_path << Dir[ File.join(File.dirname(__FILE__), 'locale', '*.{yml}') ]

# set default locale to something other than :en
I18n.default_locale = :nb

dow = I18n.l Time.now, :format => "%a"
weeknum = I18n.l Time.now, :format => "%W"

if ((dow == "tir") and (weeknum.to_i % 2 == 1))
  tweet = I18n.l Time.now, :format => config['message']['format']
  
  oauth = Twitter::OAuth.new(CONSUMER_TOKEN, CONSUMER_SECRET)
  oauth.authorize_from_access(ACCESS_TOKEN, ACCESS_SECRET)
  
  client = Twitter::Base.new(oauth)
  
  client.update(tweet)
end
