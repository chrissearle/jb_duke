#!/usr/bin/env ruby

require 'i18n'
require 'twitter'
require 'getopt/std'
require 'cinch'

require 'dukelibs'

I18n.load_path << Dir[File.join(Dir.pwd, 'locale', '*.{yml}')]
I18n.default_locale = :nb

opt = Getopt::Std.getopts("t")

config = ConfigLoader.get_config(opt['t'])

tweeter = Tweeter.new(config['tweeter'])

tweeter.enable()
tweeter.tweet(ARGV[0])
