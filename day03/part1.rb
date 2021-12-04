#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

lines = input.split("\n")

half = lines.size / 2
sums = Array.new(lines.first.size, 0)
gamma = Array.new(lines.first.size, 0)
epsilon = Array.new(lines.first.size, 0)

lines.each do |l|
  digits = l.chars

  digits.each_with_index { |d, i| sums[i] += d.to_i }
end

sums.each_with_index do |d, i|
  gamma[i] = d >= half ? 1 : 0
  epsilon[i] = gamma[i] == 1 ? 0 : 1
end

puts epsilon.join.to_i(2) * gamma.join.to_i(2)
