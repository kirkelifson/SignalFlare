# Usage:
# $ cat ~/.rvm/environments/(current ruby version) > ~/.bashrc-rvm
# $ crontab -u (user) -e
# SHELL=/bin/bash
# BASH_ENV=/home/(user)/.bashrc-rvm
# 0 0 * * * /home/(user)/.rvm/rubies/(current ruby version)/bin/ruby /path/to/script/location.rb

#!/usr/bin/env ruby

require "SignalFlare"

hostname = "test.parodybit.net"
api_key = "not_a_real_api_key"
email = "kirk@parodybit.net"

cloudflare = SignalFlare.new(api_key, email)
puts cloudflare.update_ip(hostname)
