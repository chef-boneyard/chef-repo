require "ipaddr"

module Percona
  module IPScope
    extend self

    PRIVATE_RANGES = [IPAddr.new("10.0.0.0/8"), IPAddr.new("192.168.0.0/16")]
    LOOPBACK_RANGE = IPAddr.new("0.0.0.0/8")

    def for(ipaddress)
      addr = IPAddr.new(ipaddress)

      return :private if PRIVATE_RANGES.any? { |range| range.include? addr }
      return :loopback if LOOPBACK_RANGE.include? addr
      return :public
    end
  end

  module ConfigHelper
    extend self

    def bind_to(node, interface)
      case interface.to_sym
      when :public_ip
        find_public_ip(node)
      when :private_ip
        find_private_ip(node)
      when :loopback
        find_loopback_ip(node)
      else
        find_interface_ip(node, interface)
      end
    end

    private

    def find_public_ip(node)
      return node['cloud']['public_ipv4'] if node['cloud'] && node['cloud']['public_ipv4']
      find_ip(node, :private)
    end

    def find_private_ip(node)
      return node['cloud']['local_ipv4'] if node['cloud'] && node['cloud']['local_ipv4']
      return node['cloud']['private_ipv4'] if node['cloud'] && node['cloud']['private_ipv4']
      return node['privateaddress'] if node['privateaddress']
      find_ip(node, :private)
    end

    def find_loopback_ip(node)
      find_ip(node, :loopback)
    end

    def find_ip(node, scope)
      node['network']['interfaces'].each do |ifce, attrs|
        next unless attrs['addresses']
        attrs['addresses'].each do |addr, data|
          next unless data['family'] == 'inet'
          return addr if IPScope.for(addr) == scope
        end
      end
    end

    def find_interface_ip(node, interface)
      interfaces = node['network']['interfaces']
      return unless interfaces[interface]
      addr = interfaces[interface]['addresses'].find { |ip, attrs| attrs['family'] == 'inet' }
      addr && addr[0]
    end
  end
end

