#!/usr/bin/env ruby
# frozen_string_literal: true

def common(arr, pos, most)
  half = arr.size / 2.to_f
  sum = arr.inject(0) { |s, l| s + l[pos] }

  if sum > half
    most ? 1 : 0
  elsif sum < half
    most ? 0 : 1
  else
    most ? 1 : 0
  end
end

def reduction(arr, pos, most)
  return arr if arr.size == 1

  cm = common(arr, pos, most)
  reduction(arr.select { |a| cm == a[pos] }, pos + 1, most)
end

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

lines = input.split("\n").map(&:chars).map { |l| l.map(&:to_i) }

og = reduction(lines, 0, true)
co = reduction(lines, 0, false)

puts og.join.to_i(2) * co.join.to_i(2)
