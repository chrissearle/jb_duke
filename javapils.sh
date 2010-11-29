#!/bin/bash

if [ -x /usr/local/lib/rvm ]; then
	. /usr/local/lib/rvm
else
	. $HOME/.rvm/scripts/rvm
fi

rvm 1.9.2@javapils

ruby `dirname $0`/billabong.rb
