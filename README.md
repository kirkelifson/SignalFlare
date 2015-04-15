# SignalFlare
Keep CloudFlare DNS records updated on dynamic IPs

# Usage

```
$ gem install SignalFlare

$ cat test.rb
require 'SignalFlare'

hostname = 'test.parodybit.net'
api_key = 'not_my_actual_api_key'
email = 'kirk@parodybit.net'

cloudflare = SignalFlare.new(api_key, email)
puts cloudflare.update_ip(hostname)

$ ruby test.rb
IP has been updated from 127.0.0.1 to 202.194.56.202
```
