#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

target = input.slice(13, input.size).split(', ').map { |c| c.slice(2, c.size).split('..').map(&:to_i) }

x1 = target[0][0]
x2 = target[0][1]

y1 = target[1][0]
y2 = target[1][1]

min_y = target[1][0]
max_y = min_y.abs - 1

max_x = target[0][1]

c = target[0][0] * 2
min_x = ((-1 + Math.sqrt(1 + 4 * c)) / 2).ceil

combos = (min_x..max_x).to_a.product((min_y..max_y).to_a)

sum = 0

combos.each do |c|
  vel_x = c.first
  vel_y = c.last

  x = 0
  y = 0

  loop do
    x += vel_x
    y += vel_y

    vel_y -= 1
    vel_x -= 1 if vel_x.positive?

    break if (x > x2) || (y < y1)

    if (x >= x1) && (x <= x2) && (y <= y2) && (y >= y1)
      sum += 1
      break
    end
  end
end

puts sum
