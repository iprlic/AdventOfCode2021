#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

field =  input.split("\n").map { |c| c.chars.map(&:to_i) }

x = field.first.size - 1
y = field.size - 1

sum = 0

(0..y).each do |i|
  (0..x).each do |j|
    lowest = true

    lowest = false if (i - 1 >= 0) && (field[i - 1][j] <= field[i][j])
    lowest = false if (i + 1 <= y) && (field[i + 1][j] <= field[i][j])
    lowest = false if (j - 1 >= 0) && (field[i][j - 1] <= field[i][j])
    lowest = false if (j + 1 <= x) && (field[i][j + 1] <= field[i][j])

    sum += (field[i][j] + 1) if lowest
  end
end

puts sum
