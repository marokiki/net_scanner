require "thor"
require "net_scanner"
require "net/ping"
require "ipaddr"
require "parallel"
require "socket"

module NetScanner
  class CLI < Thor
    desc "netscan [NETWORK_ADDRESS/NET_MASK]", "Scan your local network and get a list of all connected devices."

    def netscan(network_address = nil)
      if network_address.nil?
        puts "Please provide a network address."
        help
      else
        puts "Scanning network #{network_address}......"

        ip_range = IPAddr.new(network_address).to_range.to_a
        ip_range.shift # Remove network address
        ip_range.pop   # Remove broadcast address
        net_mask = network_address.split("/").last
        results = Array.new(ip_range.size)

        Parallel.each_with_index(ip_range, in_threads: 30) do |ip, index|
          if Net::Ping::External.new(ip.to_s).ping?
            results[index] = "#{ip}/#{net_mask} - Active"
          else
            results[index] =  "#{ip}/#{net_mask} - Inactive"
          end
        rescue SocketError
          results[index] =  "#{ip}/#{net_mask} - Unknown"
        end

        puts results
      end
    end
  end
end
