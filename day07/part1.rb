#!/usr/bin/env ruby
# frozen_string_literal: true

def median(array)
  sorted_array = array.sort
  count = sorted_array.size

  sorted_array[(count / 2).floor]
end

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

crabs = input.split(',').map(&:to_i)

med = median(crabs).to_i

puts crabs.reduce(0) { |sum, c| sum + (med - c).abs }
