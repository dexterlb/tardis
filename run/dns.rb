#!/usr/bin/env ruby

require 'yaml'
require 'net/http'

class DnsMonitor
  DEVICE_PARSE_REGEX = %r{
    <td>([^\s]*)\s*</td>
    \s*
    <td>((?:[0-9]+\.){3}[0-9]+)\s*</td>
    \s*
    <td>((?:[0-9A-Fa-f]{2}[:-]){5}(?:[0-9A-Fa-f]{2}))\s*</td>
  }x

  Device = Struct.new(:hostname, :ip, :mac)

  def initialize(router_host:, router_user:, router_password:,
                 hosts:, hosts_file:)
    @table_url = URI("http://#{router_host}/DHCPTable.htm")
    @table_request = Net::HTTP::Get.new(@table_url)
    @table_request.basic_auth(router_user, router_password)

    @hosts = hosts
    @hosts_file = hosts_file

    @devices = []
  end

  def connected(devices)
    return if devices.empty?
    puts 'connected: ' + devices.map(&:mac).join(', ')
    system('woosh 1 &')
  end

  def disconnected(devices)
    return if devices.empty?
    puts 'disconnected: ' + devices.map(&:mac).join(', ')
  end

  def update
    new_devices = get_devices
    return if new_devices == @devices

    connected(new_devices - @devices)
    disconnected(@devices - new_devices)

    @devices = new_devices

    save_hosts_file
    system('reload_dns')
  end

  def save_hosts_file
    # write a hosts file for all current devices
    # each line of the file has: <ip> <hostname1> <hostname2> ...
    return unless @hosts_file
    File.open(@hosts_file, 'w') do |file|
      @devices.each do |device|
        file.puts(device.ip + ' ' + hostnames(device).join(' '))
      end
    end
  end

  def hostnames(device)
    # get a list of all hostnames of a device:
    # all hostnames for its mac from @hosts and its original hostname
    hostnames = @hosts.fetch(device.mac, [])
    unless hostnames.is_a? Array
      hostnames = [hostnames]   # if it's a single hostname it might be a string
    end

    if /^[a-zA-Z0-9\-]+$/.match(device.hostname)
      hostnames << device.hostname unless hostnames.include? device.hostname
    end

    hostnames
  end

  def get_devices
    html_string = device_table_html.gsub(/[\r\n]/, '')  # remove newlines
    html_string.scan(DEVICE_PARSE_REGEX).map do |device_variables|
      Device.new(*device_variables)
    end
  end

  def device_table_html
    Net::HTTP.start(@table_url.host, @table_url.port) do |http|
      http.request(@table_request).body
    end
  end
end

class Loop
  def initialize(config_file)
    config = YAML.load(File.read(config_file))
    @monitor = DnsMonitor.new(
      router_host: config['router_host'],
      router_user: config['router_user'],
      router_password: config['router_password'],
      hosts: config['hosts'],
      hosts_file: config['hosts_file']
    )
  end

  def run
    loop do
      sleep 2.5
      @monitor.update
      GC.start
    end
  end
end

if __FILE__ == $0   # running script with "ruby foo.rb", not with irb/pry
  Loop.new(File.dirname(__FILE__) + '/tardis.conf').run
end

# vim: set shiftwidth=2:
