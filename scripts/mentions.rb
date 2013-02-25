#!/usr/bin/env ruby

require 'i18n'
require 'twitter'
require 'cinch'
require 'getopt/std'
require 'pp'

require 'dukelibs'

opt = Getopt::Std.getopts("t")

I18n.load_path << Dir[File.join(Dir.pwd, 'locale', '*.{yml}')]
I18n.default_locale = :nb

config = ConfigLoader.get_config(opt["t"])

tweeter = Tweeter.new(config['tweeter'])

tweeter.instance_variable_set(:@enabled, true)

puts tweeter.mentions