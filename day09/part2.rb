#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

field =  input.split("\n").map { |c| c.chars.map(&:to_i) }

x = field.first.size - 1
y = field.size - 1

basins = []

(0..y).each do |i|
  (0..x).each do |j|
    next if field[i][j] == 9

    added_to_basin = false

    basins.each do |basin|
      borders_basin = false
      basin.each do |p|
        borders_basin = true if ((i - 1 == p[0]) || (i + 1 == p[0])) && (p[1] == j)
        borders_basin = true if ((j - 1 == p[1]) || (j + 1 == p[1])) && (p[0] == i)
        next unless borders_basin

        basin.push([i, j])
        added_to_basin = true
        break
      end
    end

    basins.push([[i, j]]) unless added_to_basin
  end
end

new_basins = []
intersections = true
while intersections
  intersections = false
  skip = []
  (0..basins.size - 1).each do |i|
    intersection = false
    next if skip.include?(i)

    (i + 1..basins.size - 1).each do |j|
      next unless i != j && (basins[i] & basins[j]).any?

      new_basins.push(basins[i].union(basins[j]))
      skip.push(j)
      intersection = true
      intersections = true
    end
    new_basins.push(basins[i]) unless intersection
  end

  basins = new_basins
  new_basins = []
end

puts basins.map(&:size).sort.reverse.take(3).inject(1) { |a, b| a * b }
