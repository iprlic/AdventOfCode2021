#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

file_path = File.expand_path('input.txt', __dir__)

steps = File.read(file_path).split("\n").map do |a|
  on = a.split(' ').first == 'on'

  c = a.split(' ').last.split(',').map do |b|
    b.slice(2, b.size - 1).split('..').map(&:to_i)
  end

  x1 = c[0][0]
  x2 = c[0][1]

  y1 = c[1][0]
  y2 = c[1][1]

  z1 = c[2][0]
  z2 = c[2][1]

  {
    'x1' => x1,
    'x2' => x2,
    'y1' => y1,
    'y2' => y2,
    'z1' => z1,
    'z2' => z2,
    'on' => on
  }
end

ons = Set.new

steps.each do |s|
  x1 = -50
  x2 = 50

  y1 = -50
  y2 = 50

  z1 = -50
  z2 = 50

  if (s['x1'] >= -50) && (s['x1'] <= 50)
    x1 = s['x1']
  elsif s['x1'] > 50
    next
  end

  if (s['x2'] >= -50) && (s['x2'] <= 50)
    x2 = s['x2']
  elsif s['x2'] < -50
    next
  end

  if (s['y1'] >= -50) && (s['y1'] <= 50)
    y1 = s['y1']
  elsif s['y1'] > 50
    next
  end

  if (s['y2'] >= -50) && (s['y2'] <= 50)
    y2 = s['y2']
  elsif s['y2'] < -50
    next
  end

  if (s['z1'] >= -50) && (s['z1'] <= 50)
    z1 = s['z1']
  elsif s['z1'] > 50
    next
  end

  if (s['z2'] >= -50) && (s['z2'] <= 50)
    z2 = s['z2']
  elsif s['z2'] < -50
    next
  end

  (x1..x2).each do |x|
    (y1..y2).each do |y|
      (z1..z2).each do |z|
        ons.add([x, y, z]) if s['on']
        ons.delete([x, y, z]) unless s['on']
      end
    end
  end
end

puts ons.size
