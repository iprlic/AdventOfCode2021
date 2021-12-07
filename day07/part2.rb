#!/usr/bin/env ruby
# frozen_string_literal: true

def gauss(num)
  return (num + 1) * ((num + 1) / 2) if num.even?

  (((num + 1) / 2) * (num + 1)) - ((num + 1) / 2)
end

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

crabs = input.split(',').map(&:to_i)

best = (crabs.sum / crabs.size)

puts crabs.reduce(0) { |sum, c| sum + gauss((best - c).abs) }
