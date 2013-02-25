#!/usr/bin/env ruby

require 'i18n'
require 'cinch'
require 'getopt/std'
require 'pp'

require 'dukelibs'

opt = Getopt::Std.getopts("t")

config = ConfigLoader.get_config(opt["t"])

pp config
