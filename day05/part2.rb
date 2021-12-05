#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

lines = input.split("\n")

points = {}

lines.each do |l|
  line = l.split(' -> ').map { |x| x.split(',').map(&:to_i) }

  if line[0][0] == line[1][0]
    range = line[0][1] < line[1][1] ? (line[0][1]..line[1][1]).to_a : (line[1][1]..line[0][1]).to_a

    range.each do |i|
      point = "#{line[0][0]},#{i}"
      points[point] = points[point] ? points[point] + 1 : 1
    end
  elsif line[0][1] == line[1][1]
    range = line[0][0] < line[1][0] ? (line[0][0]..line[1][0]).to_a : (line[1][0]..line[0][0]).to_a

    range.each do |i|
      point = "#{i},#{line[0][1]}"
      points[point] = points[point] ? points[point] + 1 : 1
    end
  else
    range_x = line[0][1].step(line[1][1], line[0][1] < line[1][1] ? 1 : -1).to_a
    range_y = line[0][0].step(line[1][0], line[0][0] < line[1][0] ? 1 : -1).to_a

    (0..range_x.size - 1).each do |x|
      point = "#{range_y[x]},#{range_x[x]}"
      points[point] = points[point] ? points[point] + 1 : 1
    end
  end
end

cnt = 0

points.each do |_k, v|
  cnt += 1 if v >= 2
end

puts cnt
