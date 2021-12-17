#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

target = input.slice(13, input.size).split(', ').map { |c| c.slice(2, c.size).split('..') }

y1 = target[1][0].to_i

puts (y1 * (y1 + 1)) / 2
