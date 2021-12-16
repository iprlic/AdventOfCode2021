#!/usr/bin/env ruby
# frozen_string_literal: true

def get_literals(message, lit)
  sig = message.slice!(0, 1)

  lit += message.slice!(0, 4)
  if sig == '1'
    get_literals(message, lit)
  else
    lit
  end
end

def get_packets(message, total = 0, goal = nil)
  return [] if message.size < 8

  version = message.slice!(0, 3).to_i(2)
  type = message.slice!(0, 3).to_i(2)
  packets = []

  if type == 4
    value = get_literals(message, '').to_i(2)

    packets.push({
                   'version' => version,
                   'type' => type,
                   'value' => value,
                   'packets' => []
                 })
  else
    length = message.slice!(0, 1)

    if length == '0'
      bits = message.slice!(0, 15).to_i(2)
      subpackets = message.slice!(0, bits)
      packets.push({
                     'version' => version,
                     'type' => type,
                     'packets' => get_packets(subpackets)
                   })
    else
      total_children = message.slice!(0, 11).to_i(2)
      packets.push({
                     'version' => version,
                     'type' => type,
                     'packets' => get_packets(message, 0, total_children)
                   })
    end
  end

  total += 1 unless goal.nil?

  if goal.nil?
    packets += get_packets(message)
  elsif goal > total
    packets += get_packets(message, total, goal)
  end

  packets
end

def calc_value(packet)
  type = packet['type']
  packets = packet['packets']

  case type
  when 0
    val = packets.reduce(0) { |s, p| s + calc_value(p) }
  when 1
    val = packets.reduce(1) { |s, p| s * calc_value(p) }
  when 2
    val = packets.map { |p| calc_value(p) }.min
  when 3
    val = packets.map { |p| calc_value(p) }.max
  when 4
    val = packet['value']
  when 5
    val = if calc_value(packets.first) > calc_value(packets.last)
            1
          else
            0
          end
  when 6
    val = if calc_value(packets.first) < calc_value(packets.last)
            1
          else
            0
          end
  when 7
    val = if calc_value(packets.first) == calc_value(packets.last)
            1
          else
            0
          end
  end

  val
end

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

message = input.chars.map { |c| c.hex.to_s(2).rjust(4, '0') }.join

packets = get_packets(message)

puts calc_value(packets.first)
