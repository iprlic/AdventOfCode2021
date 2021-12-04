#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

puts(input.split("\n").map(&:to_i).each_cons(3).map(&:sum).each_cons(2).count { |a, b| a < b })
