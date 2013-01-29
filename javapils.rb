#!/usr/bin/env ruby

require 'rubygems'
require 'i18n'
require 'twitter'
require 'yaml'
require 'getopt/std'

require File.dirname(__FILE__) + '/javabin/beer'

opt = Getopt::Std.getopts("ctip")

@test = opt["t"]
@publish = !opt["p"]

def load_yaml_file(config_file)
  YAML::load(File.open(File.join(File.dirname(__FILE__), config_file)))
end

def test_config?(config)
  if @test
    config['test']
  else
    config
  end
end

def get_config
  @config ||= load_yaml_file('config.yml')

  test_config? @config
end

def get_beer
  @beer ||= Beer.new(get_config)
end

def get_twitter_config
  @twitter ||= load_yaml_file('javapils.yml')

  test_config? @twitter
end

def get_tokens
  config_params = get_twitter_config

  @tokens ||= {
      :consumer_token => config_params['twitter']['consumer']['token'],
      :consumer_secret => config_params['twitter']['consumer']['secret'],
      :access_token => config_params['twitter']['access']['token'],
      :access_secret => config_params['twitter']['access']['secret']
  }

  Twitter.configure do |conf|
    conf.consumer_key = @tokens[:consumer_token]
    conf.consumer_secret = @tokens[:consumer_secret]
    conf.oauth_token = @tokens[:access_token]
    conf.oauth_token_secret = @tokens[:access_secret]
  end

  @tokens
end

def get_twitter_client
  get_tokens

  @client ||= Twitter::Client.new
end

if opt["c"]
  tokens = get_tokens

  puts "CONSUMER TOKEN : #{tokens[:consumer_token]}"
  puts "CONSUMER SECRET: #{tokens[:consumer_secret]}"
  puts "ACCESS TOKEN   : #{tokens[:access_token]}"
  puts "ACCESS SECRET  : #{tokens[:access_secret]}"

  puts "FORMAT         : #{get_twitter_config['message']['format']}"
  exit
end

I18n.load_path << Dir[File.join(File.dirname(__FILE__), 'locale', '*.{yml}')]

# set default locale to something other than :en
I18n.default_locale = :nb

beer = get_beer

locations = beer.beer?

locations.each do |location|
  if @test || beer.show_beer?(location)
    message = I18n.l Time.now, :format => get_twitter_config['message']['format']

    message = message.gsub(/LOC/, beer.name(location)).gsub(/PLACE/, beer.place(location))

    if @publish
      client = get_twitter_client

      client.update(message)
    else
      puts(message)
    end
  end
end
