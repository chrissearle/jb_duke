#!/usr/bin/env ruby

require 'i18n'
require 'twitter'
require 'cinch'

require 'dukelibs'

I18n.load_path << Dir[File.join(Dir.pwd, 'locale', '*.{yml}')]
I18n.default_locale = :nb

config = ConfigLoader.get_config(true)

tweeter = Tweeter.new(config['tweeter'])

tweeter.enable()
message = I18n.l Time.now, :format => config['plugins']['java-pils']['tweet']
tweeter.tweet(message.format_string_with_hash({ :name => "Test", :place => "TestLoc"}))
