require 'open-uri'
require 'cloudflare'

class SignalFlare
  def initialize(api_key, email)
    @api_key = api_key
    @email = email
    @api =  CloudFlare::connection(api_key, email)
    @ip = fetch_ip()
  end

  def update_ip(hostname)
    split = hostname.partition('.')
    @host, @domain = split[0], split[2]

    begin
      record_id = nil

      @api.rec_load_all(@domain)['response']['recs']['objs'].each do |record|
        if record['hostname'] == hostname
          record_id = record['rec_id']
          dns_ip = record['content']
          break
        end
      end

      throw 'Suitable record not found.' if record_id == nil

      @api.rec_edit(@domain, 'A', record_id, hostname, external_ip, 1)

      return 'IP has been updated to ' + external_ip + ' from ' + dns_ip
    rescue => e
      puts e.message
    end
  end

  def fetch_ip()
    open('http://api.ipify.org').read
  end
end
