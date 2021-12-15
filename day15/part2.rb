#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

field = input.split("\n").map { |i| i.chars.map(&:to_i) }
size = field.size

new_field = []

(1..((size * 5))).each do |x|
  row = []
  (1..((size * 5))).each do |y|
    old_x = x % size - 1
    old_y = y % size - 1

    old_p = field[old_x][old_y]

    x_add =  (x - 1) / size
    y_add =  (y - 1) / size

    p = old_p + x_add + y_add

    p = p % 10 + 1 if p > 9

    row.push(p)
  end

  new_field.push(row)
end

field = new_field
size = field.size

moves = (field.size - 1) * 2

size = field.size

paths = {}
paths['0,0'] = 0

found = false
goal = "#{size - 1},#{size - 1}"

new_paths = {}

until found

  paths.each do |p, v|
    x = p.to_s.split(',')[0].to_i
    y = p.to_s.split(',')[1].to_i

    if  y < size - 1
      new_p = "#{x},#{y + 1}"
      sum = v + field[x][y + 1]

      found = true if new_p == goal

      if new_paths.key?(new_p)
        new_paths[new_p] = sum if new_paths[new_p] > sum
      else
        new_paths[new_p] = sum
      end

    end

    if x < size - 1
      new_p = "#{x + 1},#{y}"
      sum = v + field[x + 1][y]

      found = true if new_p == goal

      if new_paths.key?(new_p)
        new_paths[new_p] = sum if new_paths[new_p] > sum
      else
        new_paths[new_p] = sum
      end
    end

    if y.positive?
      new_p = "#{x},#{y - 1}"
      sum = v + field[x][y - 1]

      found = true if new_p == goal

      if new_paths.key?(new_p)
        new_paths[new_p.to_sym] = sum if new_paths[new_p] > sum
      else
        new_paths[new_p.to_sym] = sum
      end
    end

    next unless x.positive?

    new_p = "#{x - 1},#{y}"
    sum = v + field[x - 1][y]

    found = true if new_p == goal

    if new_paths.key?(new_p)
      new_paths[new_p] = sum if new_paths[new_p] > sum
    else
      new_paths[new_p] = sum
    end
  end

  paths = new_paths.clone

end

puts paths[goal]
