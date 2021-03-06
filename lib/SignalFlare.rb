require "open-uri"
require "cloudflare"

class SignalFlare
  def initialize(api_key, email)
    @api_key = api_key
    @email = email
    @api = CloudFlare::connection(api_key, email)
  end

  def update_ip(hostname)
    split = hostname.partition(".")
    host = split[0]
    domain = split[2]

    record_id = nil
    dns_ip = nil
    external_ip = fetch_ip()

    @api.rec_load_all(domain)["response"]["recs"]["objs"].each do |record|
      if record["name"] == hostname
        record_id = record["rec_id"]
        dns_ip = record["content"]
        break
      end
    end

    if record_id == nil
      print "Suitable record for #{hostname} not found."
      return
    end

    if dns_ip == external_ip
      print "IP for #{hostname} has not changed. (#{external_ip})"
      return
    end

    @api.rec_edit(domain, "A", record_id, hostname, external_ip, 1)

    print "IP for #{hostname} has been updated from #{dns_ip} to #{external_ip}"
  end

  def fetch_ip
    %x(dig +short myip.opendns.com @resolver1.opendns.com).strip
  end
end
