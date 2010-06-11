require 'rubygems'
require 'i18n'
require 'twitter'

CONSUMER_TOKEN = "BXUqN8zvIhKuO0MB9TW8w"
CONSUMER_SECRET = "i4FEs4B7nGsQTHnzFG1GaTB3ki9vrzmbcIozIE7JNjw"
ACCESS_TOKEN = "14291692-NYsi1cfRtTuwH9WZjbSDhDpVwWIRWvjvZy2JWfa3Q"
ACCESS_SECRET = "S6tQZEQckUFG7XN4fmJSkpVAclfzFzm7fitV2mnfc"



I18n.load_path << Dir[ File.join(File.dirname(__FILE__), 'locale', '*.{yml}') ]

# set default locale to something other than :en
I18n.default_locale = :nb

dow = I18n.l Time.now, :format => "%a"
weeknum = I18n.l Time.now, :format => "%W"

if ((dow == "tir") and (weeknum.to_i % 2 == 1))
  tweet = I18n.l Time.now, :format => "Oslo javaPils i dag - %d. %b - Billabong"
  
  oauth = Twitter::OAuth.new(CONSUMER_TOKEN, CONSUMER_SECRET)
  oauth.authorize_from_access(ACCESS_TOKEN, ACCESS_SECRET)
  
  client = Twitter::Base.new(oauth)
  
  client.update(tweet)
end
