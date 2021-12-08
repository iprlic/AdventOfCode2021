#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

puts input.split("\n").map { |l| l.split(' | ').last.split }
          .flatten.reduce(0) { |s, n| s + ([2, 4, 3, 7].include?(n.size) ? 1 : 0) }
