#!/usr/bin/env ruby

require 'open-uri'
require 'nokogiri'

class DnsMonitor
  def initialize(router_host: 'router',
                 router_user: 'admin',
                 router_password: 'password')
    @router_host = router_host
    @router_user = router_user
    @router_password = router_password
  end

  def router_url
    "http://#{@router_user}:#{@router_password}@#{@router_host}"
  end

  def get_data
    html = Nokogiri::HTML(open(router_url + '/DHCPTable.htm'))
  end
end

# vim: set shiftwidth=2:
