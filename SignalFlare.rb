#!/usr/bin/env ruby

require 'open-uri'
require 'cloudflare'

# Script location: /etc/init.d/cloudflare-ip-update.rb
# chmod +x /etc/init.d/cloudflare-ip-update.rb
# update-rc.d cloudflare-ip-update.rb defaults
# crontab -e ... (every 12 hours)

class SignalFlare
	def initialize(api_key, email)
		@api_key = api_key
		@email = email
		@api =  CloudFlare::connection(api_key, email)
    @ip = fetch_ip()
	end

	def update_ip(hostname)
    split = hostname.partition('.')
    @host, @domain = split[0], split[1]

    begin    
      record_id = nil
      
      @api.rec_load_all(@domain)['response']['recs']['objs'].each do |record|
        if record['hostname'] == hostname
          record_id = record['rec_id']
          dns_ip = record['content']
          break
        end
      end

      return 'Suitable record not found.' if record_id == nil

      if @ip == dns_ip
        throw 'IP has not changed.'
      else
        @api.rec_edit(@domain, 'A', record_id, hostname, external_ip, 1)
      end
    rescue => e
      puts e.message
    end
	end

  def fetch_ip()
    open('http://api.ipify.org').read
  end
end