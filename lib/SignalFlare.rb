require 'open-uri'
require 'cloudflare'

class SignalFlare
  def initialize(api_key, email)
    @api_key = api_key
    @email = email
    @api = CloudFlare::connection(api_key, email)
  end

  def update_ip(hostname)
    split = hostname.partition('.')
    @host, @domain = split[0], split[2]

    begin
      record_id = nil
      dns_ip = nil
      external_ip = fetch_ip()

      @api.rec_load_all(@domain)['response']['recs']['objs'].each do |record|
        if record['name'] == hostname
          record_id = record['rec_id']
          dns_ip = record['content']
          break
        end
      end

      return 'Suitable record for ' + hostname + ' not found.' if record_id == nil

      return 'IP for ' + hostname + ' has not changed.' if dns_ip == external_ip

      @api.rec_edit(@domain, 'A', record_id, hostname, external_ip, 1)

      return 'IP for ' + hostname + ' has been updated from' + dns_ip + ' to ' + external_ip
    rescue => e
      puts e.message
    end
  end

  def fetch_ip
    open('http://api.ipify.org').read
  end
end
